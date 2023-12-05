//
//  TaskTodoCellCollectionViewCell.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 05/12/2023.
//

import UIKit
import PaddingLabel

class TaskTodoCellCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var titlePaddingLabel: PaddingLabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
}
