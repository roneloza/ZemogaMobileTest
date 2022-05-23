//
//  PostUseCase.swift
//  ZemogaMobileTest
//
//  Created by Rone Shender Loza Aliaga on 12/05/22.
//

import Foundation
import Combine
import SwiftUI

protocol PostUseCaseInput: AnyObject {
    
    var posts: [PostModel] { get }
    var output: PostUseCaseOutput? { get set }
    
    func fetchPosts()
    func fetchUser(request: PostUserRequest)
    func fetchComments(postId: Int)
    @discardableResult func savePosts(_ items: [PostModel]) -> Future<Bool, PostsDataTransferError>
    @discardableResult func updatePost(_ item: PostModel) -> Future<Bool, PostsDataTransferError>
    @discardableResult func selectPost(id: Int) -> Future<PostModel, PostsDataTransferError>
    @discardableResult func removePost(_ item: PostModel) -> Future<Bool, PostsDataTransferError>
    @discardableResult func removePosts() -> Future<Bool, PostsDataTransferError>
}

class PostInteractor: PostUseCaseInput {
    
    private(set) var posts: [PostModel]
    weak var output: PostUseCaseOutput?
    private let dataTransferable: PostsDataTransferable
    private var cancellables = Set<AnyCancellable>()
    
    init(output: PostUseCaseOutput? = nil,
         dataTransferable: PostsDataTransferable,
         posts: [PostModel] = []) {
        self.output = output
        self.dataTransferable = dataTransferable
        self.posts = posts
    }
    
    func fetchPosts() {
        self.output?.setFetchPostsStatus(.loading)
        self.dataTransferable.fetchPosts()
            .sink(receiveCompletion: { completion in
                self.receiveCompletion(completion)
            }, receiveValue: { value in
                let posts = value.map {
                    PostModel(id: $0.id,
                              userId: $0.userId,
                              title: $0.title,
                              description: $0.body)
                }
                _ = self.savePosts(posts)
                    .sink { completion in
                        self.receiveCompletion(completion)
                    } receiveValue: {_ in
                        self.output?.setFetchPostsStatus(.success)
                        self.output?.presentPosts(self.posts)
                    }
            })
            .store(in: &self.cancellables)
    }
    
    func fetchUser(request: PostUserRequest) {
        self.dataTransferable.fetchUser(request: request)
            .sink { completion in
                self.receiveCompletion(completion)
            } receiveValue: { value in
                let user = UserModel(id: value.id,
                                     name: value.name,
                                     email: value.email,
                                     phone: value.phone,
                                     website: value.website)
                _ = self.selectPost(id: request.postId)
                    .sink { completion in
                        self.receiveCompletion(completion)
                    } receiveValue: { value in
                        let post = PostModel(id: value.id,
                                             userId: value.userId,
                                             title: value.title,
                                             description: value.description,
                                             isFavorite: value.isFavorite,
                                             user: user,
                                             comments: value.comments)
                        _ =  self.updatePost(post)
                            .sink { completion in
                                self.receiveCompletion(completion)
                            } receiveValue: { _ in
                                self.output?.presentUser(user)
                            }
                    }
            }
            .store(in: &self.cancellables)
    }
    
    func fetchComments(postId: Int) {
        self.dataTransferable.fetchComments(postId: postId)
            .sink { completion in
                self.receiveCompletion(completion)
            } receiveValue: { value in
                let comments = value.map {
                    CommentModel(id: $0.id,
                                 postId: $0.postId,
                                 name: $0.name,
                                 email: $0.email,
                                 body: $0.body)
                }
                _ = self.selectPost(id: postId)
                    .sink { completion in
                        self.receiveCompletion(completion)
                    } receiveValue: { value in
                        let post = PostModel(id: value.id,
                                             userId: value.userId,
                                             title: value.title,
                                             description: value.description,
                                             isFavorite: value.isFavorite,
                                             user: value.user,
                                             comments: comments)
                        _ =  self.updatePost(post)
                            .sink { completion in
                                self.receiveCompletion(completion)
                            } receiveValue: { _ in
                                self.output?.presentComments(comments)
                            }
                    }
            }
            .store(in: &self.cancellables)
    }
    
    @discardableResult func savePosts(_ items: [PostModel]) -> Future<Bool, PostsDataTransferError> {
        Future { promise in
            self.posts.append(contentsOf: items)
            //            DataTransferQueue.shared.queue.asyncAfter(deadline: .now() + .seconds(2)) {}
            promise(.success(true))
        }
    }
    
    @discardableResult func updatePost(_ item: PostModel) -> Future<Bool, PostsDataTransferError> {
        Future { promise in
            if let index = self.posts.firstIndex(of: item) {
                self.posts[index] = item
                self.output?.presentPost(item, at: index)
                promise(.success(true))
            } else {
                promise(.failure(PostsDataTransferError.updateError))
            }
        }
    }
    
    @discardableResult func selectPost(id: Int) -> Future<PostModel, PostsDataTransferError> {
        Future { promise in
            if let result = self.posts.first(where: { object in
                id == object.id
            }) {
                promise(.success(result))
            } else {
                promise(.failure(PostsDataTransferError.selectError))
            }
        }
    }
    
    @discardableResult func removePost(_ item: PostModel) -> Future<Bool, PostsDataTransferError> {
        Future { promise in
            if let index = self.posts.firstIndex(of: item) {
                self.posts.remove(at: index)
                self.output?.presentPosts(self.posts)
                promise(.success(true))
            } else {
                promise(.failure(PostsDataTransferError.updateError))
            }
        }
    }
    
    @discardableResult func removePosts() -> Future<Bool, PostsDataTransferError> {
        Future { promise in
            self.posts.removeAll()
            self.output?.presentPosts(self.posts)
            promise(.success(true))
        }
    }
    
    //MARK: - Helpers -
    
    private func receiveCompletion(_ completion: Subscribers.Completion<PostsDataTransferError>) {
        switch completion {
            case let .failure(error):
                self.output?.setFetchPostsStatus(.failure)
                self.output?.handleError(error)
            default: break
        }
    }
    
    private func receiveCompletion(_ completion: Subscribers.Completion<UserDataTransferError>) {
        switch completion {
            case let .failure(error):
                self.output?.handleError(error)
            default: break
        }
    }
    
    private func receiveCompletion(_ completion: Subscribers.Completion<CommentsDataTransferError>) {
        switch completion {
            case let .failure(error):
                self.output?.handleError(error)
            default: break
        }
    }
}
