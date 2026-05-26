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
    @Inject var localStorageRepository: LocalStorageRepository
    
    init() {
        fetchTodos()
    }
    
    func saveTodo(_ todo: Todo) {
        todoManager.saveTodo(todo)
        todoArray.append(todo)
    }
    
    func updateTodo(_ updatedTodo: Todo) {
        todoManager.updateTodo(updatedTodo)
        if let index = todoArray.firstIndex(
            where: { $0.id == updatedTodo.id }
        ) {
            todoArray[index] = updatedTodo
        }
    }
    
    func deleteTodo(_ deletedTodo: Todo) {
        todoManager.deleteTodo(id: deletedTodo.id)
        todoArray.removeAll {
            $0.id == deletedTodo.id
        }
    }
    
    func fetchTodos() {
        todoArray = todoManager.fetchTodos(email: localStorageRepository.getUser()?.email ?? "")
    }
    
    func hasTodo() -> Bool {
        return todoArray.count > 0
    }
}
