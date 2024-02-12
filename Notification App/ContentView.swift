import SwiftUI
import UserNotifications

struct ContentView: View {
    @StateObject private var viewModel = NotificationsViewModel()

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.notificationGroups, id: \.identifiers) { group in
                        VStack(alignment: .leading) {
                            Text(group.title)
                                .font(.headline)
                            Text(group.body)
                                .font(.subheadline)
                            ForEach(group.times, id: \.self) { time in
                                Text("Scheduled for \(time, formatter: itemFormatter)")
                                    .font(.caption)
                            }
                        }
                    }
                    .onDelete(perform: deleteNotification)
                }
                .onAppear {
                    viewModel.fetchNotifications()
                }
                Spacer()
            }
            .navigationTitle("Notifications")
            .navigationBarItems(trailing: NavigationLink(destination: AddNotificationView()) {
                Image(systemName: "plus")
            })
        }
    }

    private func deleteNotification(at offsets: IndexSet) {
        // Adjust to remove notifications based on group
        // This will require adjusting the viewModel's removeNotification function to handle group identifiers.
    }
    
    private var itemFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }
}
