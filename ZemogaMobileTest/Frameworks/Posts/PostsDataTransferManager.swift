//
//  PostsDataManagerTransferable.swift
//  ZemogaMobileTest
//
//  Created by Rone Shender Loza Aliaga on 12/05/22.
//

import Combine
import Foundation

struct PostsDataTransferManager: PostsDataTransferable {
    
    let dataTransferable: PostsDataTransferable
    
    init(_ dataTransferable: PostsDataTransferable) {
        self.dataTransferable = dataTransferable
    }
    
    func fetchPosts() -> AnyPublisher<[PostCodable], PostsDataTransferError> {
        self.dataTransferable.fetchPosts()
    }
    
    func fetchUser(request: PostUserRequest) -> AnyPublisher<UserCodable, UserDataTransferError> {
        self.dataTransferable.fetchUser(request: request)
    }
    
    func fetchComments(postId: Int) -> AnyPublisher<[CommentCodable], CommentsDataTransferError> {
        self.dataTransferable.fetchComments(postId: postId)
    }
}
