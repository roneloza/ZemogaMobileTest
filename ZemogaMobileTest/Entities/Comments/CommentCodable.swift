//
//  CommentCodable.swift
//  ZemogaMobileTest
//
//  Created by Rone Shender Loza Aliaga on 18/05/22.
//

import Foundation

struct CommentCodable: Codable {
    
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
}
