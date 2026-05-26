//
//  HomeViewController.swift
//  App_todo_ios
//

import UIKit
import Floaty
import MPInjector

struct TodoSection: Hashable {
    let status: StatusTodo
    let count: Int
    
    var title: String {
        "\(status.rawValue) (\(count))"
    }
}

final class HomeViewController: BaseViewController {
    @IBOutlet weak var taskCollectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    
    @Inject var homeViewModel: HomeViewModel
    private var dataSource: UICollectionViewDiffableDataSource<TodoSection, Todo>!
    
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
        configureDataSource()
        reloadData()
        headerView.isHidden = !homeViewModel.hasTodo()
    }
    
    private func setPopupMenuNavigationBar() {
        let handler: UIActionHandler = { action in
            switch action.title {
            case HomeViewController.settingTitle:
                self.toSettingScreen()
            default:
                self.showToast(message: "Function not available")
            }
        }
        let menu = UIMenu(title: "", children: [
            UIAction(title: HomeViewController.settingTitle, image: UIImage(systemName: "gear"), handler: handler),
            UIAction(title: HomeViewController.IdentifyPlantTitle, image: UIImage(systemName: "viewfinder"), handler: handler),
            UIAction(title: HomeViewController.plantDiaryTitle, image: UIImage(systemName: "books.vertical"), handler: handler),
            UIAction(title: HomeViewController.plantNotificationTitle, image: UIImage(systemName: "bell"), handler: handler),
            UIAction(title: HomeViewController.removePlantTitle, image: UIImage(systemName: "trash"), handler: handler)
        ])
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Manage", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.menu = menu
    }
    
    private func toSettingScreen() {
        let vc = UIStoryboard(name: "Setting", bundle: .main).instantiate(SettingViewController.self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupCollectionView() {
        taskCollectionView.delegate = self
        taskCollectionView.dataSource = nil
        taskCollectionView.register(
            UINib(nibName: "TaskTodoCellCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "TaskTodoCellCollectionViewCell"
        )
        taskCollectionView.register(
            UINib(nibName: "TaskSectionHeaderView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "TaskSectionHeaderView"
        )
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 56, height: 45)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 45)
        layout.minimumLineSpacing = 8
        
        taskCollectionView.collectionViewLayout = layout
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<TodoSection, Todo>(
            collectionView: taskCollectionView
        ) { collectionView, indexPath, todo in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "TaskTodoCellCollectionViewCell",
                for: indexPath
            ) as! TaskTodoCellCollectionViewCell
            cell.titlePaddingLabel.text = todo.title
            cell.statusLabel.text = todo.status.rawValue
            cell.statusLabel.backgroundColor = todo.status.statusColor
            return cell
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "TaskSectionHeaderView",
                for: indexPath
            ) as! TaskSectionHeaderView
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            header.titleLabel.text = section.title
            header.titleLabel.textColor = section.status.statusColor
            return header
        }
    }
    
    private func reloadData() {
        let groupedTodos: [(StatusTodo, [Todo])] = [
            (.working, homeViewModel.todoArray.filter { $0.status == .working }),
            (.stuck, homeViewModel.todoArray.filter { $0.status == .stuck }),
            (.done, homeViewModel.todoArray.filter { $0.status == .done })
        ]
        var snapshot = NSDiffableDataSourceSnapshot<TodoSection, Todo>()
        
        groupedTodos.forEach { status, todos in
            guard !todos.isEmpty else { return }
            
            let section = TodoSection(
                status: status,
                count: todos.count
            )
            
            snapshot.appendSections([section])
            snapshot.appendItems(todos, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
        
        headerView.isHidden = !homeViewModel.hasTodo()
    }
    
    private func setupFloatingButton() {
        let floaty = Floaty()
        floaty.plusColor = .white
        floaty.buttonColor = view.tintColor
        floaty.friendlyTap = true
        floaty.fabDelegate = self
        view.addSubview(floaty)
    }
    
    private func addTodoTapped() {
        let vc = UIStoryboard(name: "AddTodo", bundle: nil).instantiate(AddTodoViewController.self)
        vc.addTodoCallBackCompletion = { [weak self] todo in
            guard let self, let todo else { return }
            self.homeViewModel.saveTodo(todo)
            self.reloadData()
            self.back()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func openEditTodo(todo: Todo) {
        let vc = UIStoryboard(name: "EditTodo", bundle: nil).instantiate(EditTodoViewController.self)
        vc.selectedTodo = todo
        vc.editTodoCallBackCompletion = { [weak self] editedTodo in
            guard let self, let editedTodo else { return }
            self.homeViewModel.updateTodo(editedTodo)
            self.reloadData()
            self.back()
        }
        vc.deleteTodoCallBackCompletion = { [weak self] deletedTodo in
            guard let self, let deletedTodo else { return }
            self.homeViewModel.deleteTodo(deletedTodo)
            self.reloadData()
            self.back()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let todo = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        openEditTodo(todo: todo)
    }
}

extension HomeViewController: FloatyDelegate {
    func emptyFloatySelected(_ floaty: Floaty) {
        addTodoTapped()
    }
}
