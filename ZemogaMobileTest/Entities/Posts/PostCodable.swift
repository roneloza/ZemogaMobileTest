//
//  PostCodable.swift
//  ZemogaMobileTest
//
//  Created by Rone Shender Loza Aliaga on 12/05/22.
//

import Foundation

struct PostCodable: Codable, Equatable {
    
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
