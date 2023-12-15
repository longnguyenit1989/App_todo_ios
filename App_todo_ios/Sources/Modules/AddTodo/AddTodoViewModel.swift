//
//  AddTodoViewModel.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 04/12/2023.
//

import Foundation
import MPInjector

class AddTodoViewModel {
    var todo: Todo?
    
    @Inject var localStorageRepository: LocalStorageRepository
    
    func addTodo(title: String, content: String) {
        let timestamp = getCurrentSecond()
        todo = Todo(timestamp, title, content, StatusTodo.working, localStorageRepository.getUser()?.email ?? "")
    }
}
