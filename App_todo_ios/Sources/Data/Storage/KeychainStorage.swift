//
//  File.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 12/12/2023.
//

import Foundation
import KeychainAccess
import MPInjector

final class KeychainStorage: Storage {
    private lazy var keychain: Keychain = {
        let identifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
        return Keychain(service: identifier).accessibility(.afterFirstUnlock)
    }()
    
    func setString(key: String, value: String) {
        set(value, key)
    }
    
    func getString(key: String) -> String? {
        get(key)
    }
    
    func setDouble(key: String, value: Double) {
        set(String(value), key)
    }
    
    func getDouble(key: String) -> Double? {
        if let value = get(key) {
            return Double(value)
        }
        return nil
    }
    
    func setInt(key: String, value: Int) {
        set(String(value), key)
    }
    
    func getInt(key: String) -> Int? {
        if let value = get(key) {
            return Int(value)
        }
        return nil
    }
    
    func setBool(key: String, value: Bool) {
        set(String(value ? "1" : "0"), key)
    }
    
    func getBool(key: String) -> Bool {
        get(key) == "1" ? true : false
    }
    
    func setArray(key: String, value: [Int]) {
        let data = try? JSONSerialization.data(withJSONObject: value)
        set(data, key)
    }
    
    func getArray(key: String) -> [Int]? {
        guard let data = getData(key) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data)) as? [Int]
    }
    
    func removeKey(key: String) {
        remove(key)
    }
    
    func clear() {
        clearAll()
    }
}

extension KeychainStorage {
    func set(_ value: String?, _ key: String) {
        if let value = value {
            keychain[key] = value
            try? keychain.set(value, key: key)
        } else {
            remove(key)
        }
    }
    
    func set(_ value: Data?, _ key: String) {
        if let value = value {
            keychain[data: key] = value
            try? keychain.set(value, key: key)
        } else {
            remove(key)
        }
    }

    func get(_ key: String) -> String? {
        try? keychain.get(key)
    }
    
    func getData(_ key: String) -> Data? {
        try? keychain.getData(key)
    }
    
    func remove(_ key: String) {
        keychain[key] = nil
        try? keychain.remove(key)
    }
    
    func clearAll() {
        try? keychain.removeAll()
    }
}
