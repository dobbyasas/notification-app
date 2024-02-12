//
//  ContentView.swift
//  Notification App
//
//  Created by Kryštof Svejkovký on 06.01.2024.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    var body: some View {   
        NavigationView {
            VStack {
                Button("Send Notification") {
                    sendNotification()
                }
                .onAppear {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            print("All set!")
                        } else if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("Notifications")
            .navigationBarItems(trailing: NavigationLink(destination: AddNotificationView()) {
                Image(systemName: "plus")
            })
        }
    }
    
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Notification"
        content.body = "This is a notification"

        // prodleva 5 sekund páč se ta sračka buguje
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // vytvoření requestu
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // přidání našeho notfikation request
        UNUserNotificationCenter.current().add(request)
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
