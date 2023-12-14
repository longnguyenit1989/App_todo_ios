//
//  Todo.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 04/12/2023.
//

import Foundation

struct Todo {
    var id: Int64
    var title: String
    var content: String
    
    var status: StatusTodo
    var email: String
    
    init(_ id: Int64,_ title: String,_ content: String, _ status: StatusTodo,_ email: String) {
        self.id = id
        self.title = title
        self.content = content
        self.status = status
        self.email = email
    }
}
