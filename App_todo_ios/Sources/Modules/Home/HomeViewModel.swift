//
//  HomeViewModel.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 04/12/2023.
//

import Foundation
import MPInjector

class HomeViewModel {
    var todoArray: [Todo] = []
    
    @Inject var todoManager: TodoManager
    
    init() {
        todoArray = todoManager.fetchTodos()
    }
    
    func saveTodo(_ todo: Todo) {
        todoManager.saveTodo(todo)
    }
    
    func updateTodo(_ updatedTodo: Todo) {
        todoManager.updateTodo(updatedTodo)
    }
}
