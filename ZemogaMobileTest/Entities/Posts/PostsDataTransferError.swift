//
//  PostsDataTransferError.swift
//  ZemogaMobileTest
//
//  Created by Rone Shender Loza Aliaga on 12/05/22.
//

import Foundation

enum PostsDataTransferError: Error {
    
    case fetchError
    case saveError
    case updateError
    case selectError
    case removeError
}

enum UserDataTransferError: Error {
    
    case fetchError
}

enum CommentsDataTransferError: Error {
    
    case fetchError
}
