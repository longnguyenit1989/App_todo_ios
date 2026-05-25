//
//  HomeViewController.swift
//  App_todo_ios
//

import UIKit
import Floaty
import MPInjector

struct TodoSection {
    let title: String
    let status: StatusTodo
    var todos: [Todo]
}

final class HomeViewController: BaseViewController {
    
    @IBOutlet weak var taskCollectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    
    @Inject var homeViewModel: HomeViewModel
    
    private var sections: [TodoSection] = []
    
    private static let settingTitle = "Setting"
    private static let IdentifyPlantTitle = "Identify Plant"
    private static let plantDiaryTitle = "Plant's diary"
    private static let plantNotificationTitle = "Plant's notifications"
    private static let removePlantTitle = "Remove plant"
    
    override func setupUi() {
        setNavigationBar(title: "HOME")
        setPopupMenuNavigationBar()
        setupCollectionView()
        setupFloatingButton()
        reloadSections()
        headerView.isHidden = !homeViewModel.hasTodo()
    }
    
    private func setPopupMenuNavigationBar() {
        let menuHandler: UIActionHandler = { action in
            switch action.title {
            case HomeViewController.settingTitle:
                self.toSettingScreen()
            default:
                self.showToast(message: "Function not available")
            }
        }
        
        let barButtonMenu = UIMenu(title: "", children: [
            UIAction(title: NSLocalizedString(HomeViewController.settingTitle, comment: ""), image: UIImage(systemName: "gear") ,handler: menuHandler),
            UIAction(title: NSLocalizedString(HomeViewController.IdentifyPlantTitle, comment: ""), image: UIImage(systemName: "viewfinder"), handler: menuHandler),
            UIAction(title: NSLocalizedString(HomeViewController.plantDiaryTitle, comment: ""), image: UIImage(systemName: "books.vertical"), handler: menuHandler),
            UIAction(title: NSLocalizedString(HomeViewController.plantNotificationTitle, comment: ""), image: UIImage(systemName: "bell"), handler: menuHandler),
            UIAction(title: NSLocalizedString(HomeViewController.removePlantTitle, comment: ""), image: UIImage(systemName: "trash"), handler: menuHandler)
        ])
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Manage", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem?.menu = barButtonMenu
    }
    
    private func toSettingScreen() {
        let settingVC = UIStoryboard(name: "Setting", bundle: .main).instantiateViewController(withIdentifier: "SettingViewController")
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    private func setupCollectionView() {
        taskCollectionView.delegate = self
        taskCollectionView.dataSource = self
        taskCollectionView.register(
            UINib(
                nibName: "TaskTodoCellCollectionViewCell",
                bundle: nil
            ),
            forCellWithReuseIdentifier: "TaskTodoCellCollectionViewCell"
        )
        
        taskCollectionView.register(
            UINib(
                nibName: "TaskSectionHeaderView",
                bundle: nil
            ),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "TaskSectionHeaderView"
        )
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(
            width: UIScreen.main.bounds.width - 56,
            height: 45
        )
        
        layout.headerReferenceSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: 45
        )
        
        layout.minimumLineSpacing = 8
        taskCollectionView.collectionViewLayout = layout
    }
    
    private func setupFloatingButton() {
        let floaty = Floaty()
        floaty.plusColor = .white
        floaty.buttonColor = view.tintColor
        floaty.friendlyTap = true
        floaty.fabDelegate = self
        view.addSubview(floaty)
    }
        
    private func reloadSections() {
        let rawSections = [
            createSection(title: StatusTodo.working.rawValue, status: .working),
            createSection(title: StatusTodo.stuck.rawValue, status: .stuck),
            createSection(title: StatusTodo.done.rawValue, status: .done)
        ]
        sections = rawSections.filter { !$0.todos.isEmpty }
        taskCollectionView.reloadData()
    }
    
    private func createSection(
        title: String,
        status: StatusTodo
    ) -> TodoSection {
        let todos = homeViewModel.todoArray.filter {
            $0.status == status
        }
        let todoTitle = "\(title) (\(todos.count))"
        
        return TodoSection(
            title: todoTitle,
            status: status,
            todos: todos
        )
    }
    
    private func addTodoTapped() {
        let vc = UIStoryboard(
            name: "AddTodo",
            bundle: nil
        ).instantiate(AddTodoViewController.self)
        vc.addTodoCallBackCompletion = {
            [weak self] todo in
            guard let self, let todo else {
                return
            }
            navigationController?.popViewController(
                animated: true
            )
            homeViewModel.todoArray.append(todo)
            homeViewModel.saveTodo(todo)
            reloadSections()
            
            NotificationManager.shared.showNotification(
                title: "Todo",
                body: "You add todo: \(todo.title) success"
            )
        }
        
        navigationController?.pushViewController(vc,animated: true)
    }
    
    private func openEditTodo(todo: Todo) {
        let vc = UIStoryboard(
            name: "EditTodo",
            bundle: nil
        ).instantiate(EditTodoViewController.self)
        
        vc.selectedTodo = todo
        vc.editTodoCallBackCompletion = {
            [weak self] editedTodo in
            
            guard let self,
                  let editedTodo else {
                return
            }
            
            navigationController?.popViewController(
                animated: true
            )
            
            if let index = homeViewModel.todoArray.firstIndex(
                where: { $0.id == editedTodo.id }
            ) {
                homeViewModel.todoArray[index] = editedTodo
                homeViewModel.updateTodo(editedTodo)
            }
            NotificationManager.shared.showNotification(
                title: "Todo",
                body: "You edit todo: \(editedTodo.title) success"
            )
            
            reloadSections()
        }
        
        vc.deleteTodoCallBackCompletion = {
            [weak self] deletedTodo in
            
            guard let self,
                  let deletedTodo else {
                return
            }
            
            navigationController?.popViewController(
                animated: true
            )
            
            homeViewModel.todoArray.removeAll {
                $0.id == deletedTodo.id
            }
            homeViewModel.deleteTodo(
                deletedTodo
            )
            
            NotificationManager.shared.showNotification(
                title: "Todo",
                body: "You delete todo: \(deletedTodo.title) success"
            )
            reloadSections()
        }
        
        navigationController?.pushViewController(
            vc,
            animated: true
        )
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].todos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskTodoCellCollectionViewCell",for: indexPath) as! TaskTodoCellCollectionViewCell
        
        let todo = sections[indexPath.section].todos[indexPath.row]
        cell.titlePaddingLabel.text = todo.title
        cell.statusLabel.text = todo.status.rawValue
        cell.statusLabel.backgroundColor = todo.status.statusColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier:
                "TaskSectionHeaderView",
            for: indexPath
        ) as! TaskSectionHeaderView
        
        let section = sections[indexPath.section]
        header.titleLabel.text = section.title
        header.titleLabel.textColor = section.status.statusColor
        return header
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let todo = sections[indexPath.section].todos[indexPath.row]
        openEditTodo(todo: todo)
    }
}

extension HomeViewController: FloatyDelegate {
    func emptyFloatySelected(_ floaty: Floaty) {
        addTodoTapped()
    }
}
