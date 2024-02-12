import SwiftUI
import UserNotifications

struct ContentView: View {
    @StateObject private var viewModel = NotificationsViewModel()

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.notifications, id: \.identifier) { request in
                        VStack(alignment: .leading) {
                            Text(request.content.title)
                                .font(.headline)
                            Text(request.content.body)
                                .font(.subheadline)
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
        for index in offsets {
            let identifier = viewModel.notifications[index].identifier
            viewModel.removeNotification(by: identifier)
        }
    }
}
