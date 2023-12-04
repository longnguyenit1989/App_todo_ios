//
//  AppInjector.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 04/12/2023.
//

import MPInjector

extension MPInjector: Registering {
    public func registerService() {
        registerFactory { AddTodoViewModel() }
        registerFactory { HomeViewModel() }
    }
}
