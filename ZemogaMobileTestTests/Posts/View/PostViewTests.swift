//
//  PostViewTests.swift
//  ZemogaMobileTestTests
//
//  Created by Rone Shender Loza Aliaga on 18/05/22.
//

import XCTest
import ViewInspector
import Combine
@testable import ZemogaMobileTest

class PostViewTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPostView_whenPresentPosts_hasPosts() {
        //Given
        let exp1 = expectation(description: "when present posts has favorite posts")
        exp1.expectedFulfillmentCount = 2
        let presenter = PostPresenterMock.create()
        let interactor = PostInteractorMock.create()
        let controller = PostController(interactor: interactor,
                                        presenter: presenter)
        let view = PostView(controller: controller)
        ViewHosting.host(view: view)
        controller.$posts
            .sink(receiveValue: { value in
                exp1.fulfill()
            })
            .store(in: &self.cancellables)
        //When
        controller.posts = [
            PostModel(
                id: 1,
                userId: 1,
                title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                description: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto",
                isFavorite: true
            ),
            PostModel(
                id: 2,
                userId: 1,
                title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                description: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
            )]
        //Then
        self.wait(for: [exp1], timeout: 5.0)
        XCTAssertTrue(controller.posts.count > 0)
    }
    
    func testPostView_whenTapRefreshPosts_hasPosts() {
        //Given
        let exp1 = expectation(description: "when tap refresh then has posts")
        exp1.expectedFulfillmentCount = 2
        let presenter = PostPresenter()
        let interactor = PostInteractor(dataTransferable:
                                            PostsDataTransferManagerStub(
                                                PostsDataTransferFactoryStub().get(
                                                    .mock(PostsDataTransferStubType.success.rawValue))))
        let controller = PostController(interactor: interactor,
                                        presenter: presenter)
        let view = PostView(controller: controller)
        ViewHosting.host(view: view)
        controller.$posts
            .sink(receiveValue: { value in
                exp1.fulfill()
            })
            .store(in: &self.cancellables)
        //When
        try? view.inspect().find(viewWithTag: "button-refresh").button().tap()
        //Then
        self.wait(for: [exp1], timeout: 5.0)
        XCTAssertTrue(controller.posts.count > 0)
    }
    
    func testPostView_whenTapRemovePosts_hasNotPosts() {
        //Given
        let exp1 = expectation(description: "when present posts has favorite posts")
        exp1.expectedFulfillmentCount = 3
        let presenter = PostPresenter()
        let interactor = PostInteractor(dataTransferable:
                                            PostsDataTransferManagerStub(
                                                PostsDataTransferFactoryStub().get(
                                                    .mock(PostsDataTransferStubType.success.rawValue))))
        let controller = PostController(interactor: interactor,
                                        presenter: presenter)
        let view = PostView(controller: controller)
        ViewHosting.host(view: view)
        controller.$posts
            .sink(receiveValue: { value in
                exp1.fulfill()
            })
            .store(in: &self.cancellables)
        controller.posts = [
            PostModel(
                id: 1,
                userId: 1,
                title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                description: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto",
                isFavorite: true
            ),
            PostModel(
                id: 2,
                userId: 1,
                title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                description: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
            )]
        //When
        try? view.inspect().find(viewWithTag: "button-remove").button().tap()
        //Then
        self.wait(for: [exp1], timeout: 5.0)
        XCTAssertTrue(controller.posts.count == 0)
    }
}
