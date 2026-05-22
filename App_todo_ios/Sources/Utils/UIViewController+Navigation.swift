//
//  UIViewController+Navigation.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 22/5/26.
//
import UIKit

extension UIViewController {
    func back(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
}
