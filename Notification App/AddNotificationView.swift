import SwiftUI
import UserNotifications

struct AddNotificationView: View {
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var time = Date()
    @State private var daysOfWeek: [Bool] = Array(repeating: false, count: 7)
    @State private var showingSuccessAlert = false

    var body: some View {
        Form {
            Section(header: Text("Notification Details")) {
                TextField("Name", text: $name)
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                TextEditor(text: $description)
                    .frame(height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.secondary, lineWidth: 1)
                    )
            }
            
            Section(header: Text("Days of the Week")) {
                ForEach(0..<daysOfWeek.count, id: \.self) { index in
                    Toggle(dayOfWeekString(index), isOn: $daysOfWeek[index])
                }
            }
        }
        .navigationTitle("Add Notification")
        .navigationBarItems(trailing: Button("Add") {
            addNotification()
        })
        .alert("Scheduled", isPresented: $showingSuccessAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your notifications have been scheduled successfully.")
        }
    }

    func addNotification() {
        let notification = NotificationData(name: name, description: description, time: time, daysOfWeek: daysOfWeek)
        storeNotification(notification)
        scheduleNotificationsForSelectedDays(notification)
        showingSuccessAlert = true
    }

    private func storeNotification(_ notification: NotificationData) {
        let defaults = UserDefaults.standard
        var notifications = fetchNotifications()
        notifications.append(notification)
        if let encoded = try? JSONEncoder().encode(notifications) {
            defaults.set(encoded, forKey: "SavedNotifications")
        }
    }
    
    private func fetchNotifications() -> [NotificationData] {
        let defaults = UserDefaults.standard
        if let savedNotifications = defaults.object(forKey: "SavedNotifications") as? Data {
            if let loadedNotifications = try? JSONDecoder().decode([NotificationData].self, from: savedNotifications) {
                return loadedNotifications
            }
        }
        return []
    }
    
    private func scheduleNotificationsForSelectedDays(_ notification: NotificationData) {
        let content = UNMutableNotificationContent()
        content.title = notification.name
        content.body = notification.description
        content.sound = UNNotificationSound.default
        
        for (index, isSelected) in notification.daysOfWeek.enumerated() {
            guard isSelected else { continue }
            
            var dateComponents = DateComponents()
            dateComponents.hour = Calendar.current.component(.hour, from: notification.time)
            dateComponents.minute = Calendar.current.component(.minute, from: notification.time)
            dateComponents.weekday = index + 1
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled for \(dayOfWeekString(index)) at \(notification.time)")
                }
            }
        }
    }

    private func dayOfWeekString(_ index: Int) -> String {
        let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        return days[index]
    }
}

struct NotificationData: Codable {
    var name: String
    var description: String
    var time: Date
    var daysOfWeek: [Bool]
}

struct AddNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        AddNotificationView()
    }
}
