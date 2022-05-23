//
//  PostsDataTransferable.swift
//  ZemogaMobileTest
//
//  Created by Rone Shender Loza Aliaga on 17/05/22.
//

import Foundation
import Combine

public class DataTransferQueue {
    
    public let queue = DispatchQueue(label: "blocking",
                              qos: .background,
                              attributes: .concurrent)
    
    public static let shared = DataTransferQueue()
    
    private init() {}
}

protocol PostsDataTransferable {
    
    func fetchPosts() -> AnyPublisher<[PostCodable], PostsDataTransferError>
    func fetchUser(request: PostUserRequest) -> AnyPublisher<UserCodable, UserDataTransferError>
    func fetchComments(postId: Int) -> AnyPublisher<[CommentCodable], CommentsDataTransferError>
}

struct PostsDataTransferNetwork: PostsDataTransferable {
    
    private let settings: PostDataTransferIdentificable
    private let seconds: Double
    
    init(_ settings: PostDataTransferIdentificable,
         seconds: Double = 0.0) {
        self.settings = settings
        self.seconds = seconds
    }
    
    func fetchPosts() -> AnyPublisher<[PostCodable], PostsDataTransferError> {
        URLSession.shared.dataTaskPublisher(for: URLRequest(url: URL(string: self.settings.postsURL)!))
            .delay(for: .seconds(self.seconds), scheduler: DataTransferQueue.shared.queue)
            .map(\.data)
            .decode(type: [PostCodable].self, decoder: JSONDecoder())
            .mapError { _ in
                PostsDataTransferError.fetchError
            }
            .eraseToAnyPublisher()
    }
    
    func fetchUser(request: PostUserRequest) -> AnyPublisher<UserCodable, UserDataTransferError> {
        URLSession.shared.dataTaskPublisher(for:
                                                URLRequest(
                                                    url: URL(
                                                        string: String(format: self.settings.userURL,
                                                                       request.userId.description))!))
            .delay(for: .seconds(self.seconds), scheduler: DataTransferQueue.shared.queue)
            .map(\.data)
            .decode(type: UserCodable.self, decoder: JSONDecoder())
            .mapError { _ in
                UserDataTransferError.fetchError
            }
            .eraseToAnyPublisher()
    }
    
    func fetchComments(postId: Int) -> AnyPublisher<[CommentCodable], CommentsDataTransferError> {
        URLSession.shared.dataTaskPublisher(for:
                                                URLRequest(
                                                    url: URL(
                                                        string: String(format: self.settings.commentsURL,
                                                                       postId.description))!))
            .delay(for: .seconds(self.seconds), scheduler: DataTransferQueue.shared.queue)
            .map(\.data)
            .decode(type: [CommentCodable].self, decoder: JSONDecoder())
            .mapError { _ in
                CommentsDataTransferError.fetchError
            }
            .eraseToAnyPublisher()
    }
}
