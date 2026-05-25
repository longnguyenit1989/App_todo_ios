//
//  NotificationManager.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 25/5/26.
//

import Foundation
import UserNotifications

final class NotificationManager {

    static let shared = NotificationManager()

    private init() {}

    func showNotification(
        title: String,
        body: String
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 1,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }
}
