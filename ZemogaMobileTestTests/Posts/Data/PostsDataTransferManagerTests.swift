//
//  PostsDataTransferManagerTests.swift
//  ZemogaMobileTestTests
//
//  Created by Rone Shender Loza Aliaga on 12/05/22.
//

import XCTest
import Combine
import Foundation
import OHHTTPStubsSwift
import OHHTTPStubs
@testable import ZemogaMobileTest

class PostsDataTransferManagerTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //MARK: - Posts -
    
    func testPostsDataTransferManagerSyncFake_whenFetchPosts_isNotNil() {
        //Given
        let sut: PostsDataTransferable = PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.success.rawValue)))
        //When
        let data: [PostCodable]? = try? sut.fetchPosts().toBlocking()
        //Then
        XCTAssertNotNil(data)
    }
    
    func testPostsDataTransferManagerAsyncFake_whenFetchPosts_isNotNil() {
        //Given
        let sut: PostsDataTransferable = PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.success.rawValue)),
                                                                      seconds: 1.0)
        //When
        let data: [PostCodable]? = try? sut.fetchPosts().toBlocking()
        //Then
        XCTAssertNotNil(data)
    }
    
    func testPostsDataTransferManagerNetwork_whenFetchPosts_isNotNil() {
        //Given
        let sut: PostsDataTransferable = PostsDataTransferManager(PostsDataTransferFactory().get(.network))
        //When
        stub(condition: isHost("jsonplaceholder.typicode.com") && isPath("/posts")) { _ in
            let path = OHPathForFile("posts.json", PostsDataTransferManagerTests.self)
            return HTTPStubsResponse(fileAtPath: path!, statusCode: 200, headers: ["Content-Type" : "application/json"])
        }
        let data: [PostCodable]? = try? sut.fetchPosts().toBlocking()
        //Then
        XCTAssertNotNil(data)
    }
    
    func testPostsDataTransferManagerNetwork_whenFetchPosts_isFailure() {
        //Given
        let sut: PostsDataTransferable = PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.network))
        //When
        //Then
        stub(condition: isHost("jsonplaceholder.typicode.com") && isPath("/posts")) { _ in
            return HTTPStubsResponse(error: PostsDataTransferError.fetchError)
        }
        XCTAssertThrowsError(try sut.fetchPosts().toBlocking()) { error in
            XCTAssertTrue(error is PostsDataTransferError)
        }
    }
    
    func testPostsDataTransferManager_whenFetchPosts_throwsError() {
        //Given
        let sut: PostsDataTransferable = PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.failure.rawValue)))
        //When
        //Then
        XCTAssertThrowsError(try sut.fetchPosts().toBlocking()) { error in
            XCTAssertTrue(error is PostsDataTransferError)
        }
    }
    
    //MARK: - User -
    
    func testPostsDataTransferManagerSyncFake_whenFetchUser_isNotNil() {
        //Given
        let request = PostUserRequest(postId: 1, userId: 1)
        let sut: PostsDataTransferable = PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.success.rawValue)))
        //When
        let data = try? sut.fetchUser(request: request).toBlocking()
        //Then
        XCTAssertNotNil(data)
    }
    
    func testPostsDataTransferManagerAsyncFake_whenFetchUser_isNotNil() {
        //Given
        let request = PostUserRequest(postId: 1, userId: 1)
        let sut: PostsDataTransferable = PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.success.rawValue)),
                                                                      seconds: 1.0)
        //When
        let data = try? sut.fetchUser(request: request).toBlocking()
        //Then
        XCTAssertNotNil(data)
    }
    
    func testPostsDataTransferManagerNetwork_whenFetchUser_isNotNil() {
        //Given
        let request = PostUserRequest(postId: 1, userId: 1)
        let sut: PostsDataTransferable = PostsDataTransferManager(PostsDataTransferFactory().get(.network))
        //When
        stub(condition: isHost("jsonplaceholder.typicode.com") && isPath("/users/\(request.userId)")) { _ in
            let path = OHPathForFile("user.json", PostsDataTransferManagerTests.self)
            return HTTPStubsResponse(fileAtPath: path!, statusCode: 200, headers: ["Content-Type" : "application/json"])
        }
        let data = try? sut.fetchUser(request: request).toBlocking()
        //Then
        XCTAssertNotNil(data)
    }
    
    func testPostsDataTransferManagerNetwork_whenFetchUser_isFailure() {
        //Given
        let request = PostUserRequest(postId: 1, userId: 1)
        let sut: PostsDataTransferable = PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.network))
        //When
        //Then
        stub(condition: isHost("jsonplaceholder.typicode.com") && isPath("/users/\(request.userId)")) { _ in
            return HTTPStubsResponse(error: UserDataTransferError.fetchError)
        }
        XCTAssertThrowsError(try sut.fetchUser(request: request).toBlocking()) { error in
            XCTAssertTrue(error is UserDataTransferError)
        }
    }
    
    func testPostsDataTransferManager_whenFetchUser_throwsError() {
        //Given
        let request = PostUserRequest(postId: 1, userId: 1)
        let sut: PostsDataTransferable = PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.failure.rawValue)))
        //When
        //Then
        XCTAssertThrowsError(try sut.fetchUser(request: request).toBlocking()) { error in
            XCTAssertTrue(error is UserDataTransferError)
        }
    }
    
    //MARK: - Comments -
    
    func testPostsDataTransferManagerSyncFake_whenFetchComments_isNotNil() {
        //Given
        let postId = 1
        let sut: PostsDataTransferable = PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.success.rawValue)))
        //When
        let data = try? sut.fetchComments(postId: postId).toBlocking()
        //Then
        XCTAssertNotNil(data)
    }
    
    func testPostsDataTransferManagerAsyncFake_whenFetchComments_isNotNil() {
        //Given
        let postId = 1
        let sut: PostsDataTransferable = PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.success.rawValue)),
                                                                      seconds: 1.0)
        //When
        let data = try? sut.fetchComments(postId: postId).toBlocking()
        //Then
        XCTAssertNotNil(data)
    }

    func testPostsDataTransferManagerNetwork_whenFetchComments_isNotNil() {
        //Given
        let sut: PostsDataTransferable = PostsDataTransferManager(PostsDataTransferFactory().get(.network))
        let postId = 1
        //When
        stub(condition: isHost("jsonplaceholder.typicode.com") && isPath("/posts/\(postId)/comments")) { _ in
            let path = OHPathForFile("comments.json", PostsDataTransferManagerTests.self)
            return HTTPStubsResponse(fileAtPath: path!, statusCode: 200, headers: ["Content-Type" : "application/json"])
        }
        let data = try? sut.fetchComments(postId: postId).toBlocking()
        //Then
        XCTAssertNotNil(data)
    }

    func testPostsDataTransferManagerNetwork_whenFetchComments_isFailure() {
        //Given
        let sut: PostsDataTransferable = PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.network))
        let postId = 1
        //When
        //Then
        stub(condition: isHost("jsonplaceholder.typicode.com") && isPath("/posts/\(postId)/comments")) { _ in
            return HTTPStubsResponse(error: CommentsDataTransferError.fetchError)
        }
        XCTAssertThrowsError(try sut.fetchComments(postId: postId).toBlocking()) { error in
            XCTAssertTrue(error is CommentsDataTransferError)
        }
    }

    func testPostsDataTransferManager_whenFetchComments_throwsError() {
        //Given
        let sut: PostsDataTransferable = PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.failure.rawValue)))
        let postId = 1
        //When
        //Then
        XCTAssertThrowsError(try sut.fetchComments(postId: postId).toBlocking()) { error in
            XCTAssertTrue(error is CommentsDataTransferError)
        }
    }
}
