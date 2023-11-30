//
//  CustomButtton.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 30/11/2023.
//

import UIKit

class CustomPrimaryButtton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.backgroundColor = UIColor.systemBlue.cgColor
    }

}
