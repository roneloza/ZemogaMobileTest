//
//  DataTransferURL.swift
//  ZemogaMobileTest
//
//  Created by Rone Shender Loza Aliaga on 17/05/22.
//

import Foundation

protocol PostDataTransferIdentificable {
    
    var postsURL: String { get }
    var userURL: String { get }
    var commentsURL: String { get }
}

struct DataTransferIdentifierNetwork: PostDataTransferIdentificable {
    
    let postsURL: String = "https://jsonplaceholder.typicode.com/posts"
    let userURL: String = "https://jsonplaceholder.typicode.com/users/%@"
    let commentsURL: String = "https://jsonplaceholder.typicode.com/posts/%@/comments"
}

struct DataTransferIdentifierLocalhost: PostDataTransferIdentificable {
    
    let postsURL: String = "http://localhost:3002/posts"
    let userURL: String = "http://localhost:3002/users/%@"
    let commentsURL: String = "http://localhost:3002/posts/%@/comments"
}
