//
//  Home.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 01/12/2023.
//

import UIKit
import Floaty
import MPInjector

class HomeViewController: BaseViewController {
    @IBOutlet weak var completedCollectionView: UICollectionView!
    @IBOutlet weak var taskCollectionView: UICollectionView!
    
    @IBOutlet weak var completedStackView: UIStackView!
    @IBOutlet weak var arrowImaview: UIImageView!
    
    @Inject var homeViewModel: HomeViewModel
    
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
        floaty.buttonColor = view.tintColor
        
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
        let addTodoVC = UIStoryboard(name: "AddTodo", bundle: .main).instantiateViewController(withIdentifier: "AddTodoViewController") as! AddTodoViewController
        
        addTodoVC.addTodoCallBackCompletion = { todo in
            self.navigationController?.popViewController(animated: true)
            print("todo: \(String(describing: todo))")
        }
        
        navigationController?.pushViewController(addTodoVC, animated: true)
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
