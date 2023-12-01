//
//  UIApplication+Extension.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 01/12/2023.
//

import Foundation
import UIKit

extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
        
        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }

        return window
    }
}
