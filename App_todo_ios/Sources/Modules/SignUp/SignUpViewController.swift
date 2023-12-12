//
//  SignUp.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 30/11/2023.
//

import Foundation
import UIKit
import MPInjector

class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: CustomPrimaryTextField!
    @IBOutlet weak var passwordTextField: CustomPrimaryTextField!
    @IBOutlet weak var confirmPasswordTextField: CustomPrimaryTextField!
    
    @IBOutlet weak var signUpButton: CustomPrimaryButtton!
    
    @Inject var signUpViewModel: SignUpViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    @objc func signUpButtonTapped() {
        let email = emailTextField.text?.trim ?? ""
        let password = passwordTextField.text?.trim ?? ""
        let confirmPassword = confirmPasswordTextField.text?.trim ?? ""
        
        if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
            showToast(message: "Please fill all your infor")
        } else if (!email.isValidEmail) {
            showToast(message: "Your email is invalid")
        } else if (password != confirmPassword) {
            showToast(message: "Please fill same password and confirmPassword")
        } else {
            showToast(message: "Register success")
            self.signUpViewModel.saveUser(email, password)
            let homeVC = UIStoryboard(name: "Home", bundle: .main).instantiateViewController(withIdentifier: "HomeNavigationViewController")
            UIApplication.shared.currentUIWindow()?.rootViewController = homeVC
            UIApplication.shared.currentUIWindow()?.makeKeyAndVisible()
        }
    }
    
}
