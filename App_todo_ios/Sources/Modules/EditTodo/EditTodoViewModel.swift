//
//  EditTodoViewModel.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 06/12/2023.
//

import Foundation

class EditTodoViewModel {
    var todoEdited: Todo?
    
    func editTodo(title: String, content: String, todo: Todo?) {
        todoEdited = Todo(todo?.id ?? 1 , title, content)
    }
}
