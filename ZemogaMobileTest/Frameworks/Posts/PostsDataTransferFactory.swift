//
//  PostsDataTransferFactory.swift
//  ZemogaMobileTest
//
//  Created by Rone Shender Loza Aliaga on 17/05/22.
//

import Foundation

enum PostsDataTransferType {
    case network
    case mock(_ identifier: Int? = nil)
}

protocol PostsDataTransferFactoryProtocol {
    
    func get(_ type: PostsDataTransferType,
             seconds: Double) -> PostsDataTransferable
}

class PostsDataTransferFactory: PostsDataTransferFactoryProtocol {
    
    func get(_ type: PostsDataTransferType,
             seconds: Double = 0.0) -> PostsDataTransferable {
        switch type {
            case .network:
                return PostsDataTransferNetwork(DataTransferIdentifierNetwork(),
                                                seconds: seconds)
            default:
                return PostsDataTransferNetwork(DataTransferIdentifierLocalhost(),
                                                seconds: seconds)
        }
    }
}
