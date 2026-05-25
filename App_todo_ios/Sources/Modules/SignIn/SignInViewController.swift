//
//  ViewController.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 28/11/2023.
//

import UIKit
import MPInjector

class SignInViewController: BaseViewController {
    
    @IBOutlet weak var signInButton: CustomPrimaryButtton!
    @IBOutlet weak var emailTextField: CustomPrimaryTextField!
    @IBOutlet weak var passwordTextField: CustomPrimaryTextField!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var forgotPassLabel: UILabel!
    
    @Inject var signInViewModel: SignInViewModel
    
    override func setupUi() {
        super.setupUi()
        setUiAndClickSignUpLabel()
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        
        let tapForgotPassGesture = UITapGestureRecognizer(target: self, action: #selector(forgotPassTapped))
        forgotPassLabel.isUserInteractionEnabled = true
        forgotPassLabel.addGestureRecognizer(tapForgotPassGesture)
    }
    
    private func setUiAndClickSignUpLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signUpLabelTapped))
        signUpLabel.isUserInteractionEnabled = true
        signUpLabel.addGestureRecognizer(tapGesture)
        
        let attributedString = NSMutableAttributedString(string: signUpLabel.text ?? "")
        let range = (signUpLabel.text as NSString?)?.range(of: "Sign up") ?? NSRange(location: 0, length: 0)
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range)
        signUpLabel.attributedText = attributedString
    }
    
    @objc private func signUpLabelTapped() {
        let signUpVC = UIStoryboard(name: "SignUp", bundle: nil).instantiate(SignUpViewController.self)
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc private func forgotPassTapped() {
        print("forgotPassTapped")
    }
    
    @objc private func signInButtonTapped() {
        let email = emailTextField.text?.trim ?? ""
        let password = passwordTextField.text?.trim ?? ""
        let state = signInViewModel.login(email: email, password: password)
        handleSignIn(state)
    }
    
    private func handleSignIn(_ state: SignInState) {
        switch state {
        case .emptyFields:
            showToast(message: "Please fill all information")
        case .invalidEmail:
            showToast(message: "Invalid email")
        case .wrongCredentials:
            showToast(message: "Wrong email or password")
        case .success:
            toHomeAndSetRootViewcontroller()
        }
    }
    
    private func toHomeAndSetRootViewcontroller() {
        let homeVC = UIStoryboard(name: "Home", bundle: .main).instantiateViewController(withIdentifier: "HomeViewController")
        let nav = UINavigationController(rootViewController: homeVC)
        if let window = UIApplication.shared.currentUIWindow() {
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
    }
    
}
