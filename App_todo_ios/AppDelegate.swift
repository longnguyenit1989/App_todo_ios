//
//  AppDelegate.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 28/11/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        	
        window = UIWindow(frame: UIScreen.main.bounds)
        let loginViewController = UIStoryboard(name: "SignIn", bundle: Bundle.main).instantiateViewController(withIdentifier: "NavigationSignInViewController")
        window?.rootViewController = loginViewController
        window?.makeKeyAndVisible()
        return true
    }
}

