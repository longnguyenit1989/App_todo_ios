//
//  CustomRedButton.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 14/12/2023.
//

import Foundation
import UIKit

class CustomRedButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.backgroundColor = UIColor.systemRed.cgColor
    }

}
