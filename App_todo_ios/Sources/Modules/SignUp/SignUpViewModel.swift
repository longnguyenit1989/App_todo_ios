//
//  SignUpViewModel.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 12/12/2023.
//

import Foundation
import MPInjector

class SignUpViewModel {
    
    @Inject var todoManager: TodoManager
    
    func saveUser(_ email: String,_ password: String) {
        let user = User(email, password)
        todoManager.saveUser(user)
    }
}
