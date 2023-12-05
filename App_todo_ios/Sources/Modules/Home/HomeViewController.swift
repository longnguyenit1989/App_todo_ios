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
    
    @IBOutlet weak var taskCollectionView: UICollectionView!
    
    @Inject var homeViewModel: HomeViewModel
    
    var isShowCompletedTask = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUi() {
        addFloatingButton()
        
        setNavigationBar(title: "HOME")
        setTaskCollectionView()
    }
    
    func setTaskCollectionView() {
        taskCollectionView.dataSource = self
        taskCollectionView.delegate = self
        let nib = UINib(nibName: "TaskTodoCellCollectionViewCell", bundle: .main)
        taskCollectionView.register(nib, forCellWithReuseIdentifier: "TaskTodoCellCollectionViewCell")
    }
    
    @objc func floatingAddButtonTapped() {
        let addTodoVC = UIStoryboard(name: "AddTodo", bundle: .main).instantiateViewController(withIdentifier: "AddTodoViewController") as! AddTodoViewController
        
        addTodoVC.addTodoCallBackCompletion = { [self] todo in
            if(todo != nil) {
                self.navigationController?.popViewController(animated: true)
                self.homeViewModel.todoArray.append(todo!)
                self.taskCollectionView.reloadData()
            }
        }
        navigationController?.pushViewController(addTodoVC, animated: true)
    }
    
    func addFloatingButton() {
        let floaty = Floaty()
        floaty.plusColor = UIColor.white
        floaty.buttonColor = view.tintColor
        
        let tapFloatingGesture = UITapGestureRecognizer(target: self, action: #selector(floatingAddButtonTapped))
        floaty.isUserInteractionEnabled = true
        floaty.addGestureRecognizer(tapFloatingGesture)
        self.view.addSubview(floaty)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeViewModel.todoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskTodoCellCollectionViewCell", for: indexPath) as! TaskTodoCellCollectionViewCell
        
        let todo = self.homeViewModel.todoArray[indexPath.row]
        cell.titlePaddingLabel.text = todo.title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.size.width
        let size = CGSize(width: screenWidth, height: 50)
        return size
    }
}
