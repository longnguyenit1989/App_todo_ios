//
//  User.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 12/12/2023.
//

import Foundation

struct User {
    var email: String
    var password: String
    
    init(_ email: String,_ password: String) {
        self.email = email
        self.password = password
    }
}
