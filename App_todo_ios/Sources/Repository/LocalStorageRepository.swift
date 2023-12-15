//
//  LocalStorageRepository.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 12/12/2023.
//

import Foundation
import MPInjector

protocol LocalStorageRepository {
    func getUser() -> User?
    func setUser(user: User)
    
    func clearUser()
}

final class LocalStorage: LocalStorageRepository {
    @Inject var storage: Storage
    
    func getUser() -> User? {
        storage.getObject(key: StorageConstants.user, type: User.self)
    }
    
    func setUser(user: User) {
        storage.setObject(key: StorageConstants.user, value: user)
    }
    
    func clearUser() {
        storage.removeKey(key: StorageConstants.user)
    }
}
