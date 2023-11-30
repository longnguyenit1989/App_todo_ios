//
//  CustomePrimaryTextField.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 30/11/2023.
//

import UIKit

class CustomePrimaryTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.gray.cgColor
        
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    
}
