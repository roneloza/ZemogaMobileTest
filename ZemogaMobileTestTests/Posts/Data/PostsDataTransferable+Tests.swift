//
//  PostsDataTransferable+Tests.swift
//  ZemogaMobileTestTests
//
//  Created by Rone Shender Loza Aliaga on 17/05/22.
//

import Foundation
import Combine
@testable import ZemogaMobileTest

struct PostsDataTransferStub: PostsDataTransferable {
    
    func fetchPosts() -> AnyPublisher<[PostCodable], PostsDataTransferError> {
        return CurrentValueSubject<[PostCodable], PostsDataTransferError>(
            [PostCodable(
                userId: 1,
                id: 1,
                title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                body: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
            )])
            .eraseToAnyPublisher()
    }
    
    func fetchUser(request: PostUserRequest) -> AnyPublisher<UserCodable, UserDataTransferError> {
        return CurrentValueSubject<UserCodable, UserDataTransferError>(
            UserCodable(id: 1,
                        name: "Leanne Graham",
                        email: "Sincere@april.biz",
                        phone: "1-770-736-8031 x56442",
                        website: "hildegard.org"))
            .eraseToAnyPublisher()
    }
    
    func fetchComments(postId: Int) -> AnyPublisher<[CommentCodable], CommentsDataTransferError> {
        return CurrentValueSubject<[CommentCodable], CommentsDataTransferError>(
            [CommentCodable(id: 1,
                            postId: 1,
                            name: "id labore ex et quam laborum",
                            email: "Eliseo@gardner.biz",
                            body: "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium")])
            .eraseToAnyPublisher()
    }
}

struct PostsDataTransferErrorStub: PostsDataTransferable {
    
    func fetchPosts() -> AnyPublisher<[PostCodable], PostsDataTransferError> {
        let subject = PassthroughSubject<[PostCodable], PostsDataTransferError>()
        subject.send(completion: .failure(.fetchError))
        return subject.eraseToAnyPublisher()
    }
    
    func fetchUser(request: PostUserRequest) -> AnyPublisher<UserCodable, UserDataTransferError> {
        let subject = PassthroughSubject<UserCodable, UserDataTransferError>()
        subject.send(completion: .failure(.fetchError))
        return subject.eraseToAnyPublisher()
    }
    
    func fetchComments(postId: Int) -> AnyPublisher<[CommentCodable], CommentsDataTransferError> {
        let subject = PassthroughSubject<[CommentCodable], CommentsDataTransferError>()
        subject.send(completion: .failure(.fetchError))
        return subject.eraseToAnyPublisher()
    }
}

struct PostsDataTransferEmptyStub: PostsDataTransferable {
    
    func fetchPosts() -> AnyPublisher<[PostCodable], PostsDataTransferError> {
        Empty(completeImmediately: true).eraseToAnyPublisher()
    }
    
    func fetchUser(request: PostUserRequest) -> AnyPublisher<UserCodable, UserDataTransferError> {
        Empty(completeImmediately: true).eraseToAnyPublisher()
    }
    
    func fetchComments(postId: Int) -> AnyPublisher<[CommentCodable], CommentsDataTransferError> {
        Empty(completeImmediately: true).eraseToAnyPublisher()
    }
}

class PostsDataTransferMock: Mock<PostsDataTransferable>, PostsDataTransferable {
    
    func fetchPosts() -> AnyPublisher<[PostCodable], PostsDataTransferError> {
        self.accept() as! AnyPublisher<[PostCodable], PostsDataTransferError>
    }
    
    func fetchUser(request: PostUserRequest) -> AnyPublisher<UserCodable, UserDataTransferError> {
        self.accept() as! AnyPublisher<UserCodable, UserDataTransferError>
    }
    
    func fetchComments(postId: Int) -> AnyPublisher<[CommentCodable], CommentsDataTransferError> {
        self.accept() as! AnyPublisher<[CommentCodable], CommentsDataTransferError>
    }
}
