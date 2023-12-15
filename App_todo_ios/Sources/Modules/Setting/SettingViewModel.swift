//
//  SettingViewModel.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 14/12/2023.
//

import Foundation
import MPInjector

class SettingViewModel {
    @Inject var localStorage: LocalStorageRepository
    @Inject var todoManager: TodoManager
    
    func clearUser() {
        localStorage.clearUser()
    }
    
    func getUser() -> User? {
        return localStorage.getUser()
    }
}
