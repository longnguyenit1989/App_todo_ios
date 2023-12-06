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
    @IBOutlet weak var headerView: UIView!
    
    @Inject var homeViewModel: HomeViewModel
    
    var isShowCompletedTask = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        headerView.isHidden = homeViewModel.todoArray.count <= 0
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
        
        // set item size taskCollectionView
        let screenWidthOffset = UIScreen.main.bounds.width - 56
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidthOffset, height: 45)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        taskCollectionView.collectionViewLayout = layout
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

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeViewModel.todoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskTodoCellCollectionViewCell", for: indexPath) as! TaskTodoCellCollectionViewCell
        
        let todo = self.homeViewModel.todoArray[indexPath.row]
        cell.titlePaddingLabel.text = todo.title
        return cell
    }
}
