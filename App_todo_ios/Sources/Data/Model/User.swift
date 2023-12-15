//
//  User.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 12/12/2023.
//

import Foundation

struct User: Encodable, Decodable {
    var fullName: String
    var email: String
    var password: String
    
    init(_ fullName: String, _ email: String,_ password: String) {
        self.fullName = fullName
        self.email = email
        self.password = password
    }
}
