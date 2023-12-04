//
//  Time+Extension.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 04/12/2023.
//

import Foundation

func getCurrentSecond() -> Int64 {
    return Int64(NSDate().timeIntervalSince1970)
}
