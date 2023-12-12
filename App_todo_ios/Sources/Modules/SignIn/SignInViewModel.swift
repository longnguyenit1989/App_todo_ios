//
//  SignInViewModel.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 12/12/2023.
//

import Foundation
import MPInjector

class SignInViewModel {
    
    @Inject var todoManager: TodoManager
    
    func login(_ email: String, _ password: String) -> Bool {
        return todoManager.checkLogin(email, password)
    }
}
