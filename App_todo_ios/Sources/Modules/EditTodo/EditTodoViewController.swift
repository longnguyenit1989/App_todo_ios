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
    @IBOutlet weak var chooseStatusLabel: UILabel!
    
    @Inject var editTodoViewModel: EditTodoViewModel
    
    var statusPickerView: UIPickerView!
    var selectedTodo: Todo?
    var editTodoCallBackCompletion: ((Todo?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    override func setupUi() {
        setNavigationBar(title: "EDIT TODO")
        binDataSelectedTodo()
        setStatusPickerView()
    }
    
    func binDataSelectedTodo() {
        editTodoViewModel.todoEdited = selectedTodo
        
        titleTextField.text = self.editTodoViewModel.todoEdited?.title
        contentTextField.text = self.editTodoViewModel.todoEdited?.content
        chooseStatusLabel.text = self.editTodoViewModel.todoEdited?.status.rawValue
        chooseStatusLabel.backgroundColor = self.editTodoViewModel.todoEdited?.status.statusColor
    }
    
    func setStatusPickerView() {
        let chooseStatusLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseStatusLabelTapped))
        chooseStatusLabel.isUserInteractionEnabled = true
        chooseStatusLabel.addGestureRecognizer(chooseStatusLabelTapGesture)
        
        statusPickerView = UIPickerView.init()
        statusPickerView.delegate = self
        statusPickerView.dataSource = self
        
        statusPickerView.backgroundColor = UIColor.white
        statusPickerView.setValue(UIColor.black, forKey: "textColor")
        statusPickerView.autoresizingMask = .flexibleWidth
        statusPickerView.contentMode = .center
        statusPickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        
        statusPickerView.isHidden = true
        
        self.view.addSubview(statusPickerView)
    }
    
    @objc func chooseStatusLabelTapped() {
        statusPickerView.isHidden = false
    }
    
    @objc func editButtonTapped() {
        let titleEdited = titleTextField.text ?? ""
        let contentEdited = contentTextField.text ?? ""
        editTodoViewModel.editTodo(title: titleEdited, content: contentEdited)
        editTodoCallBackCompletion?(editTodoViewModel.todoEdited)
    }
}

extension EditTodoViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.editTodoViewModel.statusList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.editTodoViewModel.statusList[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let statusTodo = editTodoViewModel.statusList[row]
        editTodoViewModel.editStatusTodo(status: statusTodo)
        chooseStatusLabel.text = statusTodo.rawValue
        chooseStatusLabel.backgroundColor = statusTodo.statusColor
        pickerView.isHidden = true
    }
}
