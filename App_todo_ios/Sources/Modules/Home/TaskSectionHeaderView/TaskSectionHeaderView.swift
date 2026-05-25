//
//  TaskSectionHeaderView.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 25/5/26.
//

import UIKit

class TaskSectionHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.systemFont(
            ofSize: 20,
            weight: .bold
        )
    }
}
