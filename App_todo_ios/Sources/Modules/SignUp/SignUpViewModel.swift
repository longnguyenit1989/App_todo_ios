//
//  SignUpViewModel.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 12/12/2023.
//

import Foundation
import MPInjector

enum SignUpState {
    case success
    case emptyFields
    case invalidEmail
    case passwordNotMatch
    case error(String)
}

final class SignUpViewModel {
    @Inject var localStorageRepository: LocalStorageRepository
    @Inject var todoManager: TodoManager
    
    func signUp(fullName: String,
                email: String,
                password: String,
                confirmPassword: String,
                completion: @escaping (SignUpState) -> Void) {
        if (fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
            completion(.emptyFields)
            return
        }
        if (email.isValidEmail == false) {
            completion(.invalidEmail)
            return
        }
        if (password != confirmPassword) {
            completion(.passwordNotMatch)
            return
        }
        
        let user = User(fullName, email, password)
        todoManager.saveUser(
            user,
            callbackError: { message in completion(.error(message))},
            callbackSuccess: {completion(.success)})
    }
}
