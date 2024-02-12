import Foundation
import UserNotifications

struct NotificationGroup {
    var title: String
    var body: String
    var identifiers: [String]
    var times: [Date]
}

class NotificationsViewModel: ObservableObject {
    @Published var notificationGroups: [NotificationGroup] = []
    
    func fetchNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { [weak self] requests in
            DispatchQueue.main.async {
                self?.groupNotifications(requests)
            }
        }
    }
    
    private func groupNotifications(_ requests: [UNNotificationRequest]) {
        var groups: [String: NotificationGroup] = [:]
        
        for request in requests {
            let key = "\(request.content.title)\(request.content.body)"
            if var group = groups[key] {
                group.identifiers.append(request.identifier)
                if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                   let date = trigger.nextTriggerDate() {
                    group.times.append(date)
                }
                groups[key] = group
            } else {
                var times: [Date] = []
                if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                   let date = trigger.nextTriggerDate() {
                    times.append(date)
                }
                groups[key] = NotificationGroup(title: request.content.title, body: request.content.body, identifiers: [request.identifier], times: times)
            }
        }
        
        self.notificationGroups = Array(groups.values)
    }
    
    func removeNotification(by identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        fetchNotifications()
    }
}
