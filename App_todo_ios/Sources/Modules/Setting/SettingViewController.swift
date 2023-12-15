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
        dialogManager.showDialog(typeDialog: TypeDialog.OPTION_DIALOG, title: "LOGOUT DIALOG",message: "Do you want to logout ?", yesButtonLabel: "Logout", yesCallback: {
            self.settingViewModel.clearUser()
            
            let signInVC = UIStoryboard(name: "SignIn", bundle: .main).instantiateViewController(withIdentifier: "NavigationSignInViewController")
            UIApplication.shared.currentUIWindow()?.rootViewController = signInVC
            UIApplication.shared.currentUIWindow()?.makeKeyAndVisible()
        })
    }
}
