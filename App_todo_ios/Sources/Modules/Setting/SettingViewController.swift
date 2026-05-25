//
//  SettingViewController.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 14/12/2023.
//

import Foundation
import MPInjector

class SettingViewController: BaseViewController {
    
    @IBOutlet weak var signOutButton: CustomPrimaryButtton!
    @IBOutlet weak var fullNameValueLabel: UILabel!
    @IBOutlet weak var emailValueLabel: UILabel!
    
    @Inject var settingViewModel: SettingViewModel
    @Inject var dialogManager: DialogManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
    }
    
    override func setupUi() {
        setNavigationBar(title: "SETTING")
        setInforProfileFromCoreData()
    }
    
    func setInforProfileFromCoreData() {
        if let user = settingViewModel.getUser() {
            self.fullNameValueLabel.text = user.fullName
            self.emailValueLabel.text = user.email
        }
    }
    
    @objc func signOutButtonTapped() {
        dialogManager.showDialog(
            type: .option,
            title: "Logout",
            message: "Do you want to logout?",
            yesButtonTitle: "Logout",
            yesCallback: { [weak self] in
                guard let self else { return }
                
                self.settingViewModel.clearUser()
                
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "SignIn", bundle: .main)
                    let vc = storyboard.instantiateViewController(
                        withIdentifier: "NavigationSignInViewController"
                    )

                    if let window = UIApplication.shared.currentUIWindow() {
                        window.rootViewController = vc
                        window.makeKeyAndVisible()

                        UIView.transition(
                            with: window,
                            duration: 0.3,
                            options: .transitionCrossDissolve,
                            animations: nil
                        )
                    }
                }
            }
        )
    }
}
