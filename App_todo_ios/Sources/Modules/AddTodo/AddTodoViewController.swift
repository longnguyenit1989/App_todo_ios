//
//  AddTodoViewController.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 04/12/2023.
//

import Foundation
import MPInjector

class AddTodoViewController: BaseViewController {
    
    @IBOutlet weak var titleTextField: CustomPrimaryTextField!
    @IBOutlet weak var contentTextField: CustomPrimaryTextField!
    
    @IBOutlet weak var addButton: CustomPrimaryButtton!
    
    @Inject var addTodoViewModel: AddTodoViewModel
    
    var addTodoCallBackCompletion: ((Todo?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    override func setupUi() {
        setNavigationBar(title: "ADD TODO")
    }
    
    @objc func addButtonTapped() {
        let title = titleTextField.text ?? ""
        let content = contentTextField.text ?? ""
        addTodoViewModel.addTodo(title: title, content: content)
        
        if(addTodoViewModel.todo != nil) {
            addTodoCallBackCompletion?(addTodoViewModel.todo)
        }
    }
}
