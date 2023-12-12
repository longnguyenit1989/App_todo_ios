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

extension String {
    var trim: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
