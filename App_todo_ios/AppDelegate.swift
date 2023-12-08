//
//  AppDelegate.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 28/11/2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
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
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let loginViewController = UIStoryboard(name: "SignIn", bundle: Bundle.main).instantiateViewController(withIdentifier: "NavigationSignInViewController")
        window?.rootViewController = loginViewController
        window?.makeKeyAndVisible()
        return true
    }
}

