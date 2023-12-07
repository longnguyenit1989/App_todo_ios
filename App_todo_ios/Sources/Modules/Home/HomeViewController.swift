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
        
        addTodoVC.addTodoCallBackCompletion = { [self] todoAdded in
            if(todoAdded != nil) {
                self.navigationController?.popViewController(animated: true)
                self.homeViewModel.todoArray.append(todoAdded!)
                let indexPath = IndexPath(item: homeViewModel.todoArray.count - 1, section: 0)
                self.taskCollectionView.insertItems(at: [indexPath])
            }
        }
        self.navigationController?.pushViewController(addTodoVC, animated: true)
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
        cell.statusLabel.text = todo.status.rawValue
        cell.statusLabel.backgroundColor = todo.status.statusColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTodo = homeViewModel.todoArray[indexPath.row]
        let editTodoVC = UIStoryboard(name: "EditTodo", bundle: .main).instantiateViewController(withIdentifier: "EditTodoViewController") as! EditTodoViewController
        editTodoVC.selectedTodo = selectedTodo
        
        editTodoVC.editTodoCallBackCompletion = { [self] todoEdited in
            if(todoEdited != nil) {
                self.navigationController?.popViewController(animated: true)
                
                for (index, todo) in homeViewModel.todoArray.enumerated() {
                    if(todo.id == todoEdited!.id) {
                        homeViewModel.todoArray[index] = todoEdited!
                        let indexPath = IndexPath(item: index, section: 0)
                        self.taskCollectionView.reloadItems(at: [indexPath])
                        break
                    }
                }
            }
        }
        
        self.navigationController?.pushViewController(editTodoVC, animated: true)
    }
}
