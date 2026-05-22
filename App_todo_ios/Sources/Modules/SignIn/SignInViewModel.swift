//
//  SignInViewModel.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 12/12/2023.
//

import Foundation
import MPInjector

enum SignInState {
    case success
    case emptyFields
    case invalidEmail
    case wrongCredentials
}

final class SignInViewModel {
    @Inject var todoManager: TodoManager
    @Inject var localStorage: LocalStorageRepository
    
    func login(email: String, password: String) -> SignInState {
        if email.isEmpty || password.isEmpty {
            return .emptyFields
        }
        if email.isValidEmail == false {
            return .invalidEmail
        }
        let success = todoManager.checkLogin(email, password)
        return success ? .success : .wrongCredentials
    }
}
