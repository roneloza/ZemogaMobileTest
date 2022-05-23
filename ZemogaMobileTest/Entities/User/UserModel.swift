//
//  UserModel.swift
//  ZemogaMobileTest
//
//  Created by Rone Shender Loza Aliaga on 20/05/22.
//

import Foundation

struct UserModel: Identifiable {
    
    let id: Int
    let name: String
    let email: String
    let phone: String
    let website: String
    
    init(id: Int = 0,
         name: String = "",
         email: String = "",
         phone: String = "",
         website: String = "") {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.website = website
    }
}
