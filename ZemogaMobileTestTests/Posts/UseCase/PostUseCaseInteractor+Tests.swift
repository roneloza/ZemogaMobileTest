//
//  PostInteractor+Tests.swift
//  ZemogaMobileTestTests
//
//  Created by Rone Shender Loza Aliaga on 17/05/22.
//

import Foundation
import Combine
@testable import ZemogaMobileTest

class PostControllerMock: Mock<PostControllerDisplayable>, PostControllerDisplayable {
    
    var presenter: PostUseCaseOutput = PostPresenterMock.create()
    var interactor: PostUseCaseInput = PostInteractorMock.create()
    var selectedSegmented: Int = 0
    var posts: [PostModel] = []
    var fetchPostsStatus: FetchStatus = .none
    var currentPost: PostModel = PostModel()
    
    func displayFetchPostsStatus(_ status: FetchStatus) {
        self.accept(args: [status])
    }
    
    func displayPosts(_ posts: [PostModel]) {
        self.accept(args: [posts])
    }
    
    func displayPost(_ post: PostModel, at index: Int) {
        self.accept(args: [post, index])
    }
    
    func displayError(_ error: PostsDataTransferError) {
        self.accept(args: [error])
    }
    
    func displayError(_ error: UserDataTransferError) {
        self.accept(args: [error])
    }
    
    func displayError(_ error: CommentsDataTransferError) {
        self.accept(args: [error])
    }
    
    func displayUser(_ user: UserModel) {
        self.accept(args: [user])
    }
    
    func displayComments(_ comments: [CommentModel]) {
        self.accept(args: [comments])
    }
}

class PostInteractorMock: Mock<PostUseCaseInput>, PostUseCaseInput {
    
    var posts: [PostModel] = []
    var output: PostUseCaseOutput?
    
    func fetchPosts() {
        self.accept()
    }
    
    func savePosts(_ items: [PostModel]) -> Future<Bool, PostsDataTransferError> {
        self.accept(args: [items]) as! Future<Bool, PostsDataTransferError>
    }
    
    func updatePost(_ item: PostModel) -> Future<Bool, PostsDataTransferError> {
        self.accept(args: [item]) as! Future<Bool, PostsDataTransferError>
    }
    
    func selectPost(id: Int) -> Future<PostModel, PostsDataTransferError> {
        self.accept(args: [id]) as! Future<PostModel, PostsDataTransferError>
    }
    
    func removePost(_ item: PostModel) -> Future<Bool, PostsDataTransferError> {
        self.accept(args: [item]) as! Future<Bool, PostsDataTransferError>
    }
    
    func removePosts() -> Future<Bool, PostsDataTransferError> {
        self.accept() as! Future<Bool, PostsDataTransferError>
    }
    
    func fetchUser(request: PostUserRequest) {
        self.accept(args: [request])
    }
    
    func fetchComments(postId: Int) {
        self.accept(args: [postId])
    }
    
}

class PostPresenterMock: Mock<PostUseCaseOutput>, PostUseCaseOutput {
    
    var controller: PostControllerDisplayable? 
    
    func setFetchPostsStatus(_ status: FetchStatus) {
        self.accept(args: [status])
    }
    
    func presentPost(_ post: PostModel, at index: Int) {
        self.accept(args: [post, index])
    }
    
    func presentPosts(_ posts: [PostModel]) {
        self.accept(args: [posts])
    }
    
    func presentUser(_ user: UserModel) {
        self.accept(args: [user])
    }
    
    func presentComments(_ comments: [CommentModel]) {
        self.accept(args: [comments])
    }
    
    func handleError(_ error: PostsDataTransferError) {
        self.accept(args: [error])
    }
    
    func handleError(_ error: UserDataTransferError) {
        self.accept(args: [error])
    }
    
    func handleError(_ error: CommentsDataTransferError) {
        self.accept(args: [error])
    }
}

class PostInteractorSaveFailureStub: PostInteractor {
    
    override func savePosts(_ items: [PostModel]) -> Future<Bool, PostsDataTransferError> {
        Future { promise in
            promise(.failure(PostsDataTransferError.saveError))
        }
    }
    
    override func removePosts() -> Future<Bool, PostsDataTransferError> {
        Future { promise in
            promise(.failure(PostsDataTransferError.removeError))
        }
    }
}
