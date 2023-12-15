//
//  AppDelegate.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 28/11/2023.
//

import UIKit
import CoreData
import MPInjector

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    @Inject var localStorage: LocalStorageRepository
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoEntities")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        handleScreen()
        return true
    }
    
    func handleScreen() {
        let emailStorage = self.localStorage.getUser()?.email
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if (emailStorage != nil && emailStorage?.isEmpty == false) {
            // logined
            let homeVC = UIStoryboard(name: "Home", bundle: .main).instantiateViewController(withIdentifier: "HomeNavigationViewController")
            window?.rootViewController = homeVC
        } else {
            // not login
            let signInVC = UIStoryboard(name: "SignIn", bundle: Bundle.main).instantiateViewController(withIdentifier: "NavigationSignInViewController")
            window?.rootViewController = signInVC
        }
        window?.makeKeyAndVisible()
    }
}

