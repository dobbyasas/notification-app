//
//  NotificationViewModel.swift
//  Notification App
//
//  Created by Kryštof Svejkovký on 12.02.2024.
//

import Foundation
import UserNotifications

class NotificationsViewModel: ObservableObject {
    @Published var notifications: [UNNotificationRequest] = []
    
    func fetchNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                self.notifications = requests
            }
        }
    }
    
    func removeNotification(by identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        fetchNotifications()
    }

}
