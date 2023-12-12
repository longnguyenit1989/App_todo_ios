//
//  LocalStorageRepository.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 12/12/2023.
//

import Foundation
import MPInjector

protocol LocalStorageRepository {
    func getEmail() -> String?
    func setEmail(newValue: String)
    func clearEmail()
}

final class LocalStorage: LocalStorageRepository {
    @Inject var storage: Storage
    
    func getEmail() -> String? {
        storage.getString(key: StorageConstants.email)
    }
    
    func setEmail(newValue: String) {
        storage.setString(key: StorageConstants.email, value: newValue)
    }
    
    func clearEmail() {
        storage.removeKey(key: StorageConstants.email)
    }
}
