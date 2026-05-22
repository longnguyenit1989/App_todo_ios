//
//  SceneDelegate.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 22/5/26.
//

import UIKit
import MPInjector

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    @Inject var localStorage: LocalStorageRepository

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        let window = UIWindow(windowScene: windowScene)

        let emailStorage = localStorage.getUser()?.email

        if emailStorage?.isEmpty == false {

            let homeVC = UIStoryboard(name: "Home", bundle: .main)
                .instantiateViewController(
                    withIdentifier: "HomeNavigationViewController"
                )

            window.rootViewController = homeVC

        } else {

            let signInVC = UIStoryboard(name: "SignIn", bundle: .main)
                .instantiateViewController(
                    withIdentifier: "NavigationSignInViewController"
                )

            window.rootViewController = signInVC
        }

        self.window = window
        window.makeKeyAndVisible()
    }
}
