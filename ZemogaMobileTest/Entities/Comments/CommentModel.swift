//
//  CommentModel.swift
//  ZemogaMobileTest
//
//  Created by Rone Shender Loza Aliaga on 20/05/22.
//

import Foundation

struct CommentModel: Identifiable {
    
    var id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
}
