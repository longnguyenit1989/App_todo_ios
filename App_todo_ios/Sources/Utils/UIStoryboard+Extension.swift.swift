//
//  UIStoryboard+Extension.swift.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 22/5/26.
//

import UIKit

extension UIStoryboard {
    func instantiate<T: UIViewController>(_ type: T.Type) -> T {
        instantiateViewController(withIdentifier: String(describing: type)) as! T
    }
}
