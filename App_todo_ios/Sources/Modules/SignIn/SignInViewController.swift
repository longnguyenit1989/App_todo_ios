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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUi() {
        super.setupUi()
        setUiAndClickSignUpLabel()
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        
        let tapForgotPassGesture = UITapGestureRecognizer(target: self, action: #selector(forgotPassTapped))
        forgotPassLabel.isUserInteractionEnabled = true
        forgotPassLabel.addGestureRecognizer(tapForgotPassGesture)
    }
    
    func setUiAndClickSignUpLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signUpLabelTapped))
        signUpLabel.isUserInteractionEnabled = true
        signUpLabel.addGestureRecognizer(tapGesture)
        
        let attributedString = NSMutableAttributedString(string: signUpLabel.text ?? "")
        let range = (signUpLabel.text as NSString?)?.range(of: "Sign up") ?? NSRange(location: 0, length: 0)
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range)
        signUpLabel.attributedText = attributedString
    }
    
    @objc func signUpLabelTapped() {
        print("signUpLabelTapped")
        let signUpVC = UIStoryboard(name: "SignUp", bundle: .main).instantiateViewController(withIdentifier: "SignUpViewController")
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc func forgotPassTapped() {
        print("forgotPassTapped")
    }
    
    @objc func signInButtonTapped() {
        let email = emailTextField.text?.trim ?? ""
        let password = passwordTextField.text?.trim ?? ""
        
        if(email.isEmpty || password.isEmpty) {
            showToast(message: "Please fill all your infor")
        } else if (email.isValidEmail == false) {
            showToast(message: "Your email is invalid")
        } else if (self.signInViewModel.login(email, password) == false) {
            showToast(message: "Your email or password wrong, please check.")
        } else {
            self.signInViewModel.setEmailStorage(email: email)
            toHomeAndSetRootViewcontroller()
        }
    }
    
    func toHomeAndSetRootViewcontroller() {
        let homeVC = UIStoryboard(name: "Home", bundle: .main).instantiateViewController(withIdentifier: "HomeNavigationViewController")
        UIApplication.shared.currentUIWindow()?.rootViewController = homeVC
        UIApplication.shared.currentUIWindow()?.makeKeyAndVisible()
    }
    
}
