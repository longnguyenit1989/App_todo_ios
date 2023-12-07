//
//  String+Extensions.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 07/12/2023.
//

import Foundation
import UIKit

enum StatusTodo: String {
    case working = "Working"
    case done = "Done"
    case stuck = "Stuck"
}

extension StatusTodo {
    var statusColor: UIColor? {
        switch self {
        case.working:
            return UIColor.systemOrange
        case.done:
            return UIColor.systemGreen
        case.stuck:
            return UIColor.systemRed
        }
    }
}
