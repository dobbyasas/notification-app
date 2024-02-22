import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NotificationsViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.notificationGroups) { group in
                    VStack(alignment: .leading) {
                        Text(group.title).font(.headline)
                        HStack {
                            Text("Time: \(group.time, formatter: itemFormatter)").font(.subheadline)
                            Spacer()
                            Text(group.days).font(.subheadline)
                        }
                    }
                    .padding()
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Notifications")
            .onAppear {
                viewModel.fetchNotifications()
            }
            .navigationBarItems(trailing: NavigationLink(destination: Text("Add Notification View Placeholder")) {
                Image(systemName: "plus")
            })
        }
    }

    private var itemFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    private func deleteItems(at offsets: IndexSet) {
        viewModel.deleteNotifications(at: offsets)
    }
}
