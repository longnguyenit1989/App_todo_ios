//
//  Todo.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 04/12/2023.
//

import Foundation

struct Todo: Codable {
    var id: Int64
    var title: String
    var content: String
    
    //    enum CodingKeys: String, CodingKey {
    //        case id, title, content
    //        case id = "id"
    //        case title = "title"
    //        case content = "content"
    //    }
    
    init(_ id: Int64,_ title: String,_ content: String) {
        self.id = id
        self.title = title
        self.content = content
    }
    
}
