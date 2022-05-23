//
//  PostPresenter.swift
//  ZemogaMobileTest
//
//  Created by Rone Shender Loza Aliaga on 12/05/22.
//

import Foundation
import Combine
import SwiftUI

enum FetchStatus {
    
    case none
    case loading
    case success
    case failure
}

protocol PostUseCaseOutput: AnyObject {
    
    var controller: PostControllerDisplayable? { get set }
    func setFetchPostsStatus(_ status: FetchStatus)
    func presentPosts(_ posts: [PostModel])
    func presentPost(_ post: PostModel, at index: Int)
    func presentUser(_ user: UserModel)
    func presentComments(_ comments: [CommentModel])
    func handleError(_ error: PostsDataTransferError)
    func handleError(_ error: UserDataTransferError)
    func handleError(_ error: CommentsDataTransferError)
}

class PostPresenter: PostUseCaseOutput {
    
    weak var controller: PostControllerDisplayable?
    
    init(controller: PostControllerDisplayable? = nil) {
        self.controller = controller
    }
    
    func setFetchPostsStatus(_ status: FetchStatus) {
        self.controller?.displayFetchPostsStatus(status)
    }
    
    func presentPosts(_ posts: [PostModel]) {
        self.controller?.displayPosts(posts)
    }
    
    func presentPost(_ post: PostModel, at index: Int) {
        self.controller?.displayPost(post, at: index)
    }
    
    func presentUser(_ user: UserModel) {
        self.controller?.displayUser(user)
    }
    
    func presentComments(_ comments: [CommentModel]) {
        self.controller?.displayComments(comments)
    }
    
    func handleError(_ error: PostsDataTransferError) {
        self.controller?.displayError(error)
    }
    
    func handleError(_ error: UserDataTransferError) {
        self.controller?.displayError(error)
    }
    
    func handleError(_ error: CommentsDataTransferError) {
        self.controller?.displayError(error)
    }
}
