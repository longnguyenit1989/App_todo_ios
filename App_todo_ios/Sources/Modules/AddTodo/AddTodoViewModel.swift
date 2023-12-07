//
//  AddTodoViewModel.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 04/12/2023.
//

import Foundation

class AddTodoViewModel {
    var todo: Todo?
    
    func addTodo(title: String, content: String) {
        let timestamp = getCurrentSecond()
        todo = Todo(timestamp, title, content, StatusTodo.working)
    }
}
