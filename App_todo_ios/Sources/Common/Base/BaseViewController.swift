//
//  File.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 30/11/2023.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        bindDatas()
    }
    
    func bindDatas() {}
    func setupUi() {}
    
}
