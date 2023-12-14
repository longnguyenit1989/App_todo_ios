//
//  AppInjector.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 04/12/2023.
//

import MPInjector

extension MPInjector: Registering {
    public func registerService() {
        // MARK: Viewmodel
        registerFactory { AddTodoViewModel() }
        registerFactory { HomeViewModel() }
        registerFactory { EditTodoViewModel() }
        registerFactory { SignUpViewModel() }
        registerFactory { SignInViewModel() }
        registerFactory { SettingViewModel() }
        
        // MARK: Manager
        registerSingleton { TodoManager() }
        
        // MARK: Storage
        registerSingleton { KeychainStorage() as Storage }
        
        // MARK: Repository
        registerSingleton { LocalStorage() as LocalStorageRepository }
    }
}
