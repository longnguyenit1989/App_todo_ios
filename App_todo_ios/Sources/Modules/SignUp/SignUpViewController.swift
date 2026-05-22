//
//  SignUp.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 30/11/2023.
//
import UIKit
import MPInjector

final class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: CustomPrimaryTextField!
    @IBOutlet weak var passwordTextField: CustomPrimaryTextField!
    @IBOutlet weak var confirmPasswordTextField: CustomPrimaryTextField!
    @IBOutlet weak var fullNameTextField: CustomPrimaryTextField!
    @IBOutlet weak var signUpButton: CustomPrimaryButtton!
    
    @Inject var viewModel: SignUpViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    private func setupActions() {
        signUpButton.addTarget(self, action: #selector(onSignUpTapped), for: .touchUpInside)
    }
    
    @objc private func onSignUpTapped() {
        let fullName = fullNameTextField.text?.trim ?? ""
        let email = emailTextField.text?.trim ?? ""
        let password = passwordTextField.text?.trim ?? ""
        let confirmPassword = confirmPasswordTextField.text?.trim ?? ""
        viewModel.signUp(fullName: fullName,
                         email: email,
                         password: password,
                         confirmPassword: confirmPassword) { [weak self] in
            self?.handleSignUp($0)
        }
    }
    
    private func handleSignUp(_ state: SignUpState) {
        switch state {
        case .emptyFields:
            showToast(message: "Please fill all information")
        case .invalidEmail:
            showToast(message: "Invalid email")
        case .passwordNotMatch:
            showToast(message: "Passwords do not match")
        case .error(let message):
            showToast(message: message)
        case .success:
            back()
        }
    }

}
