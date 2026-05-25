//
//  EditTodoViewModel.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 06/12/2023.
//

import Foundation

class EditTodoViewModel {
    var todoEdited: Todo?
    let statusList = [StatusTodo.working, StatusTodo.done, StatusTodo.stuck]
        
    func editTodo(title: String, content: String) {
        todoEdited?.title = title
        todoEdited?.content = content
    }
    
    func editStatusTodo(status: StatusTodo) {
        todoEdited?.status = status
    }
    
    func deleteTodo() {
        
    }
}
