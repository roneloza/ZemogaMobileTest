//
//  PostInteractorTests.swift
//  ZemogaMobileTestTests
//
//  Created by Rone Shender Loza Aliaga on 17/05/22.
//

import XCTest
@testable import ZemogaMobileTest

class PostInteractorTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //MARK: - Posts -
    
    func testPostInteractor_whenFetchPosts_ifSuccessfulWillPresentPosts() {
        //Given
        let mock = PostPresenterMock.create()
        let sut: PostUseCaseInput = PostInteractor(output: mock,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.success.rawValue))))
        let postsExpected = [PostModel(
            id: 1,
            userId: 1,
            title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
            description: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
        )]
        mock.expect { mock in
            mock.setFetchPostsStatus(.loading)
        }
        mock.expect { mock in
            mock.setFetchPostsStatus(.success)
        }
        mock.expect { mock in
            mock.presentPosts(postsExpected)
        }
        //When
        sut.fetchPosts()
        //Then
        mock.verify()
        XCTAssertEqual(postsExpected, sut.posts)
    }
    
    func testPostInteractor_whenFetchPosts_ifSuccessfulWillDisplayPosts() {
        //Given
        let mock = PostControllerMock.create()
        let presenter = PostPresenter(controller: mock)
        let sut: PostUseCaseInput = PostInteractor(output: presenter,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.success.rawValue))))
        let postsExpected = [PostModel(
            id: 1,
            userId: 1,
            title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
            description: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
        )]
        mock.expect { mock in
            mock.displayFetchPostsStatus(.loading)
        }
        mock.expect { mock in
            mock.displayFetchPostsStatus(.success)
        }
        mock.expect { mock in
            mock.displayPosts(postsExpected)
        }
        //When
        sut.fetchPosts()
        //Then
        mock.verify()
        XCTAssertEqual(postsExpected, sut.posts)
    }
    
    func testPostInteractor_whenFetchPostsAndSavePosts_ifFailureWillHandleError() {
        //Given
        let mock = PostPresenterMock.create()
        let sut: PostUseCaseInput = PostInteractorSaveFailureStub(
            output: mock,
            dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.success.rawValue))))
        mock.expect { mock in
            mock.setFetchPostsStatus(.loading)
        }
        mock.expect { mock in
            mock.setFetchPostsStatus(.failure)
        }
        mock.expect { mock in
            mock.handleError(PostsDataTransferError.saveError)
        }
        //When
        sut.fetchPosts()
        //Then
        mock.verify()
    }
    
    func testPostInteractor_whenFetchPostsAndSavePosts_ifFailureWillDisplayError() {
        //Given
        let mock = PostControllerMock.create()
        let presenter = PostPresenter(controller: mock)
        let sut: PostUseCaseInput = PostInteractorSaveFailureStub(
            output: presenter,
            dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.success.rawValue))))
        mock.expect { mock in
            mock.displayFetchPostsStatus(.loading)
        }
        mock.expect { mock in
            mock.displayFetchPostsStatus(.failure)
        }
        mock.expect { mock in
            mock.displayError(PostsDataTransferError.saveError)
        }
        //When
        sut.fetchPosts()
        //Then
        mock.verify()
    }
    
    func testPostInteractor_whenFetchPosts_ifFailureWillHandleError() {
        //Given
        let mock = PostPresenterMock.create()
        let sut: PostUseCaseInput = PostInteractor(output: mock,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.failure.rawValue))))
        mock.expect { mock in
            mock.setFetchPostsStatus(.loading)
        }
        mock.expect { mock in
            mock.setFetchPostsStatus(.failure)
        }
        mock.expect { mock in
            mock.handleError(PostsDataTransferError.fetchError)
        }
        //When
        sut.fetchPosts()
        //Then
        mock.verify()
    }
    
    func testPostInteractor_whenFetchPosts_ifFailureWillDisplayError() {
        //Given
        let mock = PostControllerMock.create()
        let presenter = PostPresenter(controller: mock)
        let sut: PostUseCaseInput = PostInteractor(output: presenter,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.failure.rawValue))))
        mock.expect { mock in
            mock.displayFetchPostsStatus(.loading)
        }
        mock.expect { mock in
            mock.displayFetchPostsStatus(.failure)
        }
        mock.expect { mock in
            mock.displayError(PostsDataTransferError.fetchError)
        }
        //When
        sut.fetchPosts()
        //Then
        mock.verify()
    }
    
    func testPostInteractor_whenSavePosts_ifSuccessfulWillAppendPosts() {
        //Given
        let posts = [PostModel(
            id: 1,
            userId: 1,
            title: "A",
            description: "AA"
        )]
        let sut: PostUseCaseInput = PostInteractor(output: nil,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.empty.rawValue))))
        //When
        let result = try? sut.savePosts(posts).toBlocking()
        //Then
        XCTAssertEqual(true, result)
        XCTAssertEqual(posts, sut.posts)
    }
    
    func testPostInteractor_whenSavePosts_ifFailureWillHandleError() {
        //Given
        let posts = [PostModel(
            id: 1,
            userId: 1,
            title: "A",
            description: "AA"
        )]
        let sut: PostUseCaseInput = PostInteractorSaveFailureStub(output: nil,
                                                                  dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.empty.rawValue))))
        let previousPosts = sut.posts
        //When
        XCTAssertThrowsError(try sut.savePosts(posts).toBlocking()) { _ in
            //Then
            XCTAssertEqual(previousPosts, sut.posts)
        }
    }
    
    //MARK: - Post -
    
    func testPostInteractor_whenUpdatePost_ifSuccessfulWillEditPost() {
        //Given
        let posts = [PostModel(
            id: 1,
            userId: 1,
            title: "A",
            description: "AA"
        )]
        let newPost = PostModel(
            id: 1,
            userId: 1,
            title: "B",
            description: "BB"
        )
        let sut: PostUseCaseInput = PostInteractor(output: nil,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.empty.rawValue))))
        _ = try? sut.savePosts(posts).toBlocking()
        //When
        let result = try? sut.updatePost(newPost).toBlocking()
        //Then
        let updated = try? sut.selectPost(id: 1).toBlocking()
        XCTAssertEqual(true, result)
        XCTAssertEqual(updated, newPost)
    }
    
    func testPostInteractor_whenUpdatePost_ifSuccessfulPresentPost() {
        //Given
        let posts = [PostModel(
            id: 1,
            userId: 1,
            title: "A",
            description: "AA"
        )]
        let newPost = PostModel(
            id: 1,
            userId: 1,
            title: "B",
            description: "BB"
        )
        let mock = PostPresenterMock.create()
        let sut: PostUseCaseInput = PostInteractor(output: mock,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.empty.rawValue))))
        _ = try? sut.savePosts(posts).toBlocking()
        mock.expect { mock in
            mock.presentPost(newPost, at: 0)
        }
        //When
        let result = try? sut.updatePost(newPost).toBlocking()
        //Then
        let updated = try? sut.selectPost(id: 1).toBlocking()
        mock.verify()
        XCTAssertEqual(true, result)
        XCTAssertEqual(updated, newPost)
    }
    
    func testPostInteractor_whenUpdatePost_ifSuccessfulDisplayPost() {
        //Given
        let posts = [PostModel(
            id: 1,
            userId: 1,
            title: "A",
            description: "AA"
        )]
        let newPost = PostModel(
            id: 1,
            userId: 1,
            title: "B",
            description: "BB"
        )
        let mock = PostControllerMock.create()
        let presenter = PostPresenter(controller: mock)
        let sut: PostUseCaseInput = PostInteractor(output: presenter,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.empty.rawValue))))
        _ = try? sut.savePosts(posts).toBlocking()
        mock.expect { mock in
            mock.displayPost(newPost, at: 0)
        }
        //When
        let result = try? sut.updatePost(newPost).toBlocking()
        //Then
        let updated = try? sut.selectPost(id: 1).toBlocking()
        mock.verify()
        XCTAssertEqual(true, result)
        XCTAssertEqual(updated, newPost)
    }
    
    func testPostInteractor_whenUpdatePost_ifFailureWillHandleError() {
        //Given
        let posts = [PostModel(
            id: 1,
            userId: 1,
            title: "A",
            description: "AA"
        )]
        let newPost = PostModel(
            id: 2,
            userId: 2,
            title: "B",
            description: "BB"
        )
        let sut: PostUseCaseInput = PostInteractor(output: nil,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.empty.rawValue))))
        _ = try? sut.savePosts(posts).toBlocking()
        //When
        XCTAssertThrowsError(try sut.updatePost(newPost).toBlocking()) { _ in
            //Then
            XCTAssertNotEqual(newPost, sut.posts.last)
        }
    }
    
    func testPostInteractor_whenSelectPost_ifFailureWillHandleError() {
        //Given
        let sut: PostUseCaseInput = PostInteractor(output: nil,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.empty.rawValue))))
        //When
        //Then
        XCTAssertThrowsError(try sut.selectPost(id: 1).toBlocking())
    }
    
    func testPostInteractor_whenRemovePost_ifSuccessfulWillRemovePost() {
        //Given
        let posts = [PostModel(
            id: 1,
            userId: 1,
            title: "A",
            description: "AA"
        )]
        let newPost = PostModel(
            id: 1,
            userId: 1,
            title: "B",
            description: "BB"
        )
        let sut: PostUseCaseInput = PostInteractor(output: nil,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.empty.rawValue))))
        _ = try? sut.savePosts(posts).toBlocking()
        //When
        let result = try? sut.removePost(newPost).toBlocking()
        //Then
        XCTAssertEqual(true, result)
    }
    
    func testPostInteractor_whenRemovePost_ifFailureWillHandleError() {
        //Given
        let post = PostModel(
            id: 1,
            userId: 1,
            title: "B",
            description: "BB"
        )
        let sut: PostUseCaseInput = PostInteractor(output: nil,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.empty.rawValue))))
        //When
        //Then
        XCTAssertThrowsError(try sut.removePost(post).toBlocking())
    }
    
    func testPostInteractor_whenRemovePosts_ifSuccessfulWillRemovePost() {
        //Given
        let posts = [PostModel(
            id: 1,
            userId: 1,
            title: "A",
            description: "AA"
        )]
        let sut: PostUseCaseInput = PostInteractor(output: nil,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.empty.rawValue))))
        _ = try? sut.savePosts(posts).toBlocking()
        //When
        let result = try? sut.removePosts().toBlocking()
        //Then
        XCTAssertEqual(true, result)
        XCTAssertEqual(0, sut.posts.count)
    }
    
    func testPostInteractor_whenRemovePosts_ifFailureWillHandleError() {
        //Given
        let post = PostModel(
            id: 1,
            userId: 1,
            title: "B",
            description: "BB"
        )
        let sut: PostUseCaseInput = PostInteractorSaveFailureStub(output: nil,
                                                                  dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.empty.rawValue))))
        //When
        //Then
        XCTAssertThrowsError(try sut.removePost(post).toBlocking())
    }
    
    //MARK: - User -
    
    func testPostInteractor_whenFetchUserAndUpdatePost_ifSuccessfulWillPresentPost() {
        //Given
        let request = PostUserRequest(postId: 1, userId: 1)
        let userExpected = UserModel(id: 1,
                             name: "Leanne Graham",
                             email: "Sincere@april.biz",
                             phone: "1-770-736-8031 x56442",
                             website: "hildegard.org")
        let postExpected = PostModel(
            id: 1,
            userId: 1,
            title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
            description: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto",
            user: userExpected
        )
        let posts = [postExpected]
        let mock = PostPresenterMock.create()
        let sut: PostUseCaseInput = PostInteractor(output: mock,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.success.rawValue))),
                                                   posts: posts)
        mock.expect { mock in
            mock.presentPost(postExpected, at: 0)
        }
        mock.expect { mock in
            mock.presentUser(userExpected)
        }
        //When
        sut.fetchUser(request: request)
        //Then
        mock.verify()
    }
    
    func testPostInteractor_whenFetchUserAndUpdatePost_ifSuccessfulWillDisplayUser() {
        //Given
        let request = PostUserRequest(postId: 1, userId: 1)
        let userExpected = UserModel(id: 1,
                                     name: "Leanne Graham",
                                     email: "Sincere@april.biz",
                                     phone: "1-770-736-8031 x56442",
                                     website: "hildegard.org")
        let postExpected = PostModel(
            id: 1,
            userId: 1,
            title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
            description: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto",
            user: userExpected
        )
        let posts = [postExpected]
        let mock = PostControllerMock.create()
        let presenter = PostPresenter(controller: mock)
        let sut: PostUseCaseInput = PostInteractor(output: presenter,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.success.rawValue))),
                                                   posts: posts)
        mock.expect { mock in
            mock.displayPost(postExpected, at: 0)
        }
        mock.expect { mock in
            mock.displayUser(userExpected)
        }
        //When
        sut.fetchUser(request: request)
        //Then
        mock.verify()
    }
    
    func testPostInteractor_whenFetchUserAndUpdatePost_ifFailureWillHandleError() {
        //Given
        let request = PostUserRequest(postId: 1, userId: 1)
        let mock = PostPresenterMock.create()
        let sut: PostUseCaseInput = PostInteractor(output: mock,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.failure.rawValue))))
        mock.expect { mock in
            mock.handleError(UserDataTransferError.fetchError)
        }
        //When
        sut.fetchUser(request: request)
        //Then
        mock.verify()
    }
    
    func testPostInteractor_whenFetchUserAndUpdatePost_ifFailureWillDisplayError() {
        //Given
        let request = PostUserRequest(postId: 1, userId: 1)
        let mock = PostControllerMock.create()
        let presenter = PostPresenter(controller: mock)
        let sut: PostUseCaseInput = PostInteractor(output: presenter,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.failure.rawValue))))
        mock.expect { mock in
            mock.displayError(UserDataTransferError.fetchError)
        }
        //When
        sut.fetchUser(request: request)
        //Then
        mock.verify()
    }
    
    //MARK: - Comments -
    
    func testPostInteractor_whenFetchCommentsAndUpdatePost_ifSuccessfulWillPresentComments() {
        //Given
        let postExpected = PostModel(
            id: 1,
            userId: 1,
            title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
            description: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
        )
        let posts = [postExpected]
        let commentsExpected = [CommentModel(id: 1,
                                     postId: 1,
                                     name: "id labore ex et quam laborum",
                                     email: "Eliseo@gardner.biz",
                                     body: "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium")]
        let mock = PostPresenterMock.create()
        let sut: PostUseCaseInput = PostInteractor(output: mock,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.success.rawValue))),
                                                   posts: posts)
        mock.expect { mock in
            mock.presentPost(postExpected, at: 0)
        }
        mock.expect { mock in
            mock.presentComments(commentsExpected)
        }
        //When
        sut.fetchComments(postId: 1)
        //Then
        mock.verify()
    }
    
    func testPostInteractor_whenFetchCommentsAndUpdatePost_ifSuccessfulWillDisplayComments() {
        //Given
        let postExpected = PostModel(
            id: 1,
            userId: 1,
            title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
            description: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
        )
        let posts = [postExpected]
        let commentsExpected = [CommentModel(id: 1,
                                             postId: 1,
                                             name: "id labore ex et quam laborum",
                                             email: "Eliseo@gardner.biz",
                                             body: "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium")]
        let mock = PostControllerMock.create()
        let presenter = PostPresenter(controller: mock)
        let sut: PostUseCaseInput = PostInteractor(output: presenter,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.success.rawValue))),
                                                   posts: posts)
        mock.expect { mock in
            mock.displayPost(postExpected, at: 0)
        }
        mock.expect { mock in
            mock.displayComments(commentsExpected)
        }
        //When
        sut.fetchComments(postId: 1)
        //Then
        mock.verify()
    }
    
    func testPostInteractor_whenFetchComments_ifFailureWillHandleError() {
        //Given
        let mock = PostPresenterMock.create()
        let sut: PostUseCaseInput = PostInteractor(output: mock,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.failure.rawValue))))
        mock.expect { mock in
            mock.handleError(CommentsDataTransferError.fetchError)
        }
        //When
        sut.fetchComments(postId: 1)
        //Then
        mock.verify()
    }
    
    func testPostInteractor_whenFetchComments_ifFailureWillDisplayError() {
        //Given
        let mock = PostControllerMock.create()
        let presenter = PostPresenter(controller: mock)
        let sut: PostUseCaseInput = PostInteractor(output: presenter,
                                                   dataTransferable: PostsDataTransferManagerStub(PostsDataTransferFactoryStub().get(.mock(PostsDataTransferStubType.failure.rawValue))))
        mock.expect { mock in
            mock.displayError(CommentsDataTransferError.fetchError)
        }
        //When
        sut.fetchComments(postId: 1)
        //Then
        mock.verify()
    }
}
