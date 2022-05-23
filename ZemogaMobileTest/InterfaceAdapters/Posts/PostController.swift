//
//  PostController.swift
//  ZemogaMobileTest
//
//  Created by Rone Shender Loza Aliaga on 20/05/22.
//

import Foundation

import Foundation
import Combine
import SwiftUI

protocol PostControllerDisplayable: AnyObject {
    
    var presenter: PostUseCaseOutput { get }
    var interactor: PostUseCaseInput { get }
    var selectedSegmented: Int { get }
    var posts: [PostModel] { get }
    var fetchPostsStatus: FetchStatus { get }
    var currentPost: PostModel { get }
    
    func displayFetchPostsStatus(_ status: FetchStatus)
    func displayPosts(_ posts: [PostModel])
    func displayPost(_ post: PostModel, at index: Int)
    func displayError(_ error: PostsDataTransferError)
    func displayError(_ error: UserDataTransferError)
    func displayError(_ error: CommentsDataTransferError)
    func displayUser(_ user: UserModel)
    func displayComments(_ comments: [CommentModel])
}

class PostController: ObservableObject, PostControllerDisplayable {
    
    let presenter: PostUseCaseOutput
    let interactor: PostUseCaseInput
    @Published var selectedSegmented: Int = 0
    @Published var posts: [PostModel] = []
    var favorites: [PostModel] {
        self.posts.filter { $0.isFavorite }
    }
    var all: [PostModel] {
        self.posts.sorted { $0.isFavorite && !$1.isFavorite }
    }
    @Published var fetchPostsStatus: FetchStatus = .none
    var currentPost: PostModel = PostModel()
    
    init(interactor: PostUseCaseInput =
         PostInteractor(
            dataTransferable: PostsDataTransferManager(
                PostsDataTransferFactory().get(.mock()))),
         presenter: PostUseCaseOutput = PostPresenter()) {
        self.interactor = interactor
        self.presenter = presenter
        self.presenter.controller = self
        self.interactor.output = self.presenter
    }
    
    func displayFetchPostsStatus(_ status: FetchStatus) {
        DispatchQueue.main.async {
            self.fetchPostsStatus = status
        }
    }
    
    func displayPosts(_ posts: [PostModel]) {
        DispatchQueue.main.async {
            self.posts = posts
        }
    }
    
    func displayPost(_ post: PostModel, at index: Int) {
        DispatchQueue.main.async {
            self.posts[index] = post
        }
    }
    
    func displayError(_ error: PostsDataTransferError) {
        DispatchQueue.main.async {
            print(error)
        }
    }
    
    func displayError(_ error: UserDataTransferError) {
        DispatchQueue.main.async {
            print(error)
        }
    }
    
    func displayError(_ error: CommentsDataTransferError) {
        DispatchQueue.main.async {
            print(error)
        }
    }
    
    func displayUser(_ user: UserModel) {
        DispatchQueue.main.async {
            self.currentPost.user = user
        }
    }
    
    func displayComments(_ comments: [CommentModel]) {
        DispatchQueue.main.async {
            self.currentPost.comments = comments
        }
    }
    
}
