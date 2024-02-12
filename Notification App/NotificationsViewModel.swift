import Foundation
import UserNotifications

struct NotificationGroup: Identifiable {
    var id: String { title + String(time.hashValue) }
    var title: String
    var time: Date
    var days: String
}


struct GroupedNotification {
    var id: String
    var time: Date
    var weekday: Int
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
        var groups: [String: [GroupedNotification]] = [:]

        for request in requests {
            let key = request.content.title
            if let trigger = request.trigger as? UNCalendarNotificationTrigger,
               let time = trigger.nextTriggerDate(),
               let weekday = trigger.dateComponents.weekday {
                let notification = GroupedNotification(id: request.identifier, time: time, weekday: weekday)
                groups[key, default: []].append(notification)
            }
        }

        self.notificationGroups = groups.map { key, notifications in
            let sortedNotifications = notifications.sorted { $0.weekday < $1.weekday }
            let days = sortedNotifications.map { dayOfWeekString($0.weekday) }.joined(separator: ", ")
            let time = sortedNotifications.first!.time
            return NotificationGroup(title: key, time: time, days: days)
        }
    }


    
    private func dayOfWeekString(_ weekday: Int) -> String {
        let formatter = DateFormatter()
        return formatter.weekdaySymbols[weekday - 1]
    }
}
