//
//  Home.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 01/12/2023.
//

import UIKit
import Floaty

class HomeViewController: BaseViewController {
    @IBOutlet weak var completedCollectionView: UICollectionView!
    @IBOutlet weak var taskCollectionView: UICollectionView!
    
    @IBOutlet weak var completedStackView: UIStackView!
    @IBOutlet weak var arrowImaview: UIImageView!
    
    var isShowCompletedTask = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setClickCompletedStackView()
        addFloatingButton()
    }
    
    override func setupUi() {
        setNavigationBar(title: "HOME")
    }
    
    func addFloatingButton() {
        let floaty = Floaty()
        floaty.plusColor = UIColor.white
        floaty.buttonColor = UIColor.systemBlue
        
        let tapFloatingGesture = UITapGestureRecognizer(target: self, action: #selector(floatingButtonTapped))
        floaty.isUserInteractionEnabled = true
        floaty.addGestureRecognizer(tapFloatingGesture)
        self.view.addSubview(floaty)
    }
    
    func setClickCompletedStackView() {
        let completedStackViewGesture = UITapGestureRecognizer(target: self, action: #selector(completedStackViewTapped))
        completedStackView.isUserInteractionEnabled = true
        completedStackView.addGestureRecognizer(completedStackViewGesture)
    }
    
    @objc func floatingButtonTapped() {
        print("floatingButtonTapped")
    }
    
    @objc func completedStackViewTapped() {
        isShowCompletedTask = !isShowCompletedTask
        completedCollectionView.isHidden = !isShowCompletedTask
        if(isShowCompletedTask) {
            arrowImaview.image = UIImage(systemName: "chevron.down")
        } else {
            arrowImaview.image = UIImage(systemName: "chevron.up")
        }
    }
    
}
