//
//  DialogManager.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 15/12/2023.
//

import UIKit

enum DialogType {
    case close
    case retry
    case option
}

final class DialogManager {    
    private var isDialogShowing = false
    
    func showDialog(
        type: DialogType,
        title: String? = nil,
        message: String? = nil,
        yesButtonTitle: String? = nil,
        closeButtonTitle: String? = nil,
        yesCallback: (() -> Void)? = nil,
        closeCallback: (() -> Void)? = nil
    ) {
        guard !isDialogShowing else {
            return
        }
        isDialogShowing = true
        
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        switch type {
        case .close:
            alertController.addAction(
                createAction(
                    title: closeButtonTitle ?? "Close",
                    style: .default,
                    callback: closeCallback
                )
            )
            
        case .retry:
            alertController.addAction(
                createAction(
                    title: yesButtonTitle ?? "Retry",
                    style: .default,
                    callback: yesCallback
                )
            )
            alertController.addAction(
                createAction(
                    title: closeButtonTitle ?? "Close",
                    style: .cancel,
                    callback: closeCallback
                )
            )
            
        case .option:
            alertController.addAction(
                createAction(
                    title: yesButtonTitle ?? "Yes",
                    style: .destructive,
                    callback: yesCallback
                )
            )
            alertController.addAction(
                createAction(
                    title: closeButtonTitle ?? "No",
                    style: .cancel,
                    callback: closeCallback
                )
            )
        }
        present(alertController)
    }
    
    private func createAction(
        title: String,
        style: UIAlertAction.Style,
        callback: (() -> Void)?
    ) -> UIAlertAction {
        return UIAlertAction(
            title: title,
            style: style
        ) { [weak self] _ in
            
            self?.isDialogShowing = false
            callback?()
        }
    }
    
    private func present(_ alertController: UIAlertController) {
        guard let topViewController = topViewController() else {
            isDialogShowing = false
            return
        }
        topViewController.present(
            alertController,
            animated: true
        )
    }
    
    private func topViewController(
        controller: UIViewController? = UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
    ) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(
                controller: navigationController.visibleViewController
            )
        }
        if let tabBarController = controller as? UITabBarController {
            return topViewController(
                controller: tabBarController.selectedViewController
            )
        }
        if let presentedViewController = controller?.presentedViewController {
            return topViewController(
                controller: presentedViewController
            )
        }
        return controller
    }
}

