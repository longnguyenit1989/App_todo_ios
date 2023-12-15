//
//  DialogManager.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 15/12/2023.
//

import Foundation
import UIKit

enum TypeDialog {
    case CLOSE_DIALOG
    case RETRY_DIALOG
    case OPTION_DIALOG
}

class DialogManager {
    
    private var isShowedDialog = false
    
    func showDialog(typeDialog: TypeDialog,
                    title: String? = nil,
                    message: String? = nil,
                    yesButtonLabel: String? = nil,
                    closeButtonLabel: String? = nil,
                    closeCallback: (() -> Void)? = nil,
                    yesCallback: (() -> Void)? = nil) {
        
        if isShowedDialog {
            return
        }
        isShowedDialog = true
        
        switch typeDialog {
        case .CLOSE_DIALOG:
            createCloseDialog(title: title, message: message, closeButtonLabel: closeButtonLabel, closeCallback: closeCallback)
        case .RETRY_DIALOG:
            createRetryDialog(title: title, message: message, closeButtonLabel: closeButtonLabel, yesButtonLabel: yesButtonLabel, yesCallback: yesCallback, closeCallback: closeCallback)
        case .OPTION_DIALOG:
            createOptionDialog(title: title, message: message, closeButtonLabel: closeButtonLabel, yesButtonLabel: yesButtonLabel, closeCallback: closeCallback, yesCallback: yesCallback)
        }
    }
    
    private func createCloseDialog(title: String?,
                                   message: String?,
                                   closeButtonLabel: String?,
                                   closeCallback: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: closeButtonLabel ?? "Close", style: .default, handler: { _ in
            self.isShowedDialog = false
            closeCallback?()
        }))
        
        presentAlertController(alertController)
    }
    
    private func createRetryDialog(title: String?,
                                   message: String?,
                                   closeButtonLabel: String?,
                                   yesButtonLabel: String?,
                                   yesCallback: (() -> Void)?,
                                   closeCallback: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: yesButtonLabel ?? "Retry", style: .default, handler: { _ in
            self.isShowedDialog = false
            yesCallback?()
        }))
        
        alertController.addAction(UIAlertAction(title: closeButtonLabel ?? "Close", style: .default, handler: { _ in
            self.isShowedDialog = false
            closeCallback?()
        }))
        
        presentAlertController(alertController)
    }
    
    private func createOptionDialog(title: String?,
                                    message: String?,
                                    closeButtonLabel: String?,
                                    yesButtonLabel: String?,
                                    closeCallback: (() -> Void)?,
                                    yesCallback: (() -> Void)?
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: yesButtonLabel ?? "Yes", style: .default, handler: { _ in
            self.isShowedDialog = false
            yesCallback?()
        }))
        
        alertController.addAction(UIAlertAction(title: closeButtonLabel ?? "Close", style: .default, handler: { _ in
            self.isShowedDialog = false
            closeCallback?()
        }))
        
        presentAlertController(alertController)
    }
    
    private func presentAlertController(_ alertController: UIAlertController) {
        if let topViewController = UIApplication.shared.currentUIWindow()?.rootViewController {
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
}

