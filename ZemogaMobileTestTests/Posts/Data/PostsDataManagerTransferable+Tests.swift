//
//  PostsDataManagerTransferable+Tests.swift
//  ZemogaMobileTestTests
//
//  Created by Rone Shender Loza Aliaga on 17/05/22.
//

import Foundation
import Combine
@testable import ZemogaMobileTest

class PostsDataTransferManagerStub: PostsDataTransferable {
    
    private let dataTransferable: PostsDataTransferable
    private let seconds: Double = 0.0
    
    init(_ dataTransferable: PostsDataTransferable,
         seconds: Double = 0.0) {
        self.dataTransferable = dataTransferable
    }
    
    func fetchPosts() -> AnyPublisher<[PostCodable], PostsDataTransferError> {
        self.dataTransferable.fetchPosts().toPublisherBlocking(seconds: self.seconds)
    }
    
    func fetchUser(request: PostUserRequest) -> AnyPublisher<UserCodable, UserDataTransferError> {
        self.dataTransferable.fetchUser(request: request).toPublisherBlocking(seconds: self.seconds)
    }
    
    func fetchComments(postId: Int) -> AnyPublisher<[CommentCodable], CommentsDataTransferError> {
        self.dataTransferable.fetchComments(postId: postId).toPublisherBlocking(seconds: self.seconds)
    }
}

enum PostsDataTransferStubType: Int {
    case failure
    case success
    case empty
}

class PostsDataTransferFactoryStub: PostsDataTransferFactory {
    
    override func get(_ type: PostsDataTransferType,
                      seconds: Double = 0.0) -> PostsDataTransferable {
        switch type {
            case let .mock(identifier):
                switch PostsDataTransferStubType(rawValue: (identifier ?? 0)) {
                    case .failure:
                        return PostsDataTransferManagerStub(PostsDataTransferErrorStub(),
                                                            seconds: seconds)
                    case .success:
                        return PostsDataTransferManagerStub(PostsDataTransferStub(),
                                                            seconds: seconds)
                    default:
                        return PostsDataTransferEmptyStub()
                }
            default:
                return super.get(type, seconds: seconds)
        }
    }
}
