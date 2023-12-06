//
//  EditTodo.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 06/12/2023.
//

import Foundation
import MPInjector

class EditTodoViewController: BaseViewController {
    @IBOutlet weak var titleTextField: CustomPrimaryTextField!
    @IBOutlet weak var contentTextField: CustomPrimaryTextField!
    @IBOutlet weak var editButton: CustomPrimaryButtton!
    
    @Inject var editTodoViewModel: EditTodoViewModel
    var selectedTodo: Todo?
    var editTodoCallBackCompletion: ((Todo?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    override func setupUi() {
        setNavigationBar(title: "EDIT TODO")
        setInforSelectedTodo()
    }
    
    func setInforSelectedTodo() {
        titleTextField.text = self.selectedTodo?.title
        contentTextField.text = self.selectedTodo?.content
    }
    
    @objc func addButtonTapped() {
        let titleEdited = titleTextField.text ?? ""
        let contentEdited = contentTextField.text ?? ""
        editTodoViewModel.editTodo(title: titleEdited, content: contentEdited, todo: selectedTodo)
        editTodoCallBackCompletion?(editTodoViewModel.todoEdited)
    }
    
}
