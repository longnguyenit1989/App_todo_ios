//
//  ViewController.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 28/11/2023.
//

import UIKit

class SignInViewController: BaseViewController {

    @IBOutlet weak var signInButton: CustomPrimaryButtton!
    @IBOutlet weak var emailTextField: CustomePrimaryTextField!
    @IBOutlet weak var passwordTextField: CustomePrimaryTextField!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var forgotPassLabel: UILabel!
    
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
        let signUpVC = UIStoryboard(name: "SignUp", bundle: .main).instantiateViewController(withIdentifier: "SignUpViewController")
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc func forgotPassTapped() {
        print("forgotPassTapped")
    }
    
    @objc func signInButtonTapped() {
        print("Sign in")
    }
    
}

