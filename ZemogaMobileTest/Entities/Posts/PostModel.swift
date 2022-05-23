//
//  PostModel.swift
//  ZemogaMobileTest
//
//  Created by Rone Shender Loza Aliaga on 17/05/22.
//

import Foundation

class PostModel: ObservableObject, Identifiable, Equatable {
    
    let id: Int
    let userId: Int
    let title: String
    let description: String
    @Published var isFavorite: Bool
    @Published var user: UserModel
    @Published var comments: [CommentModel]
    
    init(id: Int = 0,
         userId: Int = 0,
         title: String = "",
         description: String = "",
         isFavorite: Bool = false,
         user: UserModel = UserModel(),
         comments: [CommentModel] = []) {
        self.id = id
        self.userId = userId
        self.title = title
        self.description = description
        self.isFavorite = isFavorite
        self.comments = comments
        self.user = user
    }
    
    static func == (lhs: PostModel, rhs: PostModel) -> Bool {
        return lhs.id == rhs.id && lhs.userId == rhs.userId
    }
}
