//
//  Storage.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 12/12/2023.
//

import Foundation

enum StorageConstants {
    static let user = "user"
}

protocol Storage {
    func setString(key: String, value: String)
    func getString(key: String) -> String?
    
    func setDouble(key: String, value: Double)
    func getDouble(key: String) -> Double?
    
    func setInt(key: String, value: Int)
    func getInt(key: String) -> Int?
    
    func setBool(key: String, value: Bool)
    func getBool(key: String) -> Bool
    
    func setArray(key: String, value: [Int])
    func getArray(key: String) -> [Int]?
    
    func setObject<T: Encodable>(key: String, value: T)
    func getObject<T: Decodable>(key: String, type: T.Type) -> T?
    
    func removeKey(key: String)
    func clear()
}
