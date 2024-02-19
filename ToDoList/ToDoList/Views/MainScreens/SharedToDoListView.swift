import SwiftUI
import FirebaseFirestore

struct SharedToDoListView: View {
    
    @StateObject var viewModelToDoList: ToDoListViewViewModel
    @StateObject var viewModelNotification = NotificationViewViewModel()
    @FirestoreQuery var sendNotifications: [Notification]
    private var haptic = HapticTrigger()
    @State private var selectionPicker = 0
    
    init(userId: String) {
        self._viewModelToDoList = StateObject(wrappedValue: ToDoListViewViewModel(userId: userId))
        self._sendNotifications = FirestoreQuery(collectionPath: "users/\(userId)/sendNotifications/")
    }
    
    //MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack {
                
                Divider()
                
                HStack {
                    Picker("menu", selection: $selectionPicker) {
                        Text("Notifications").tag(0)
                        Text("Send Requests").tag(1)
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal, 10)
                
                Spacer()
                
                
                switch selectionPicker {
                case 0: notifications()
                case 1: sendRequests()
                default: Text("Error")
                }
                
            }
            .navigationTitle("Shared")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        self.haptic.feedbackMedium()
                        viewModelToDoList.isPresentingView = true
                    }) {
                        Image(systemName: "paperplane")
                    }
                    .accessibilityLabel("Add new Item")
                }
            }
        }
        .sheet(isPresented: $viewModelToDoList.isPresentingView) {
            NavigationStack {
                RequestNewItemView(toggleView: $viewModelToDoList.isPresentingView)
            }
        }
        
    }
    
    @ViewBuilder
    func notifications() -> some View {
        List{
            ForEach(viewModelNotification.notifications) { notification in
                NotificationView(
                    taskObject: notification,
                    textTask: notification.task.title,
                    sendFrom: notification.senderName
                )
            }
            .onDelete { indexSet in
                withAnimation {
                    for index in indexSet {
                        self.haptic.feedbackLight()
                        viewModelNotification.deleteNotification(notification: viewModelNotification.notifications[index])
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .onAppear {
            viewModelNotification.fetchNotifications()
        }
    }
    
    @ViewBuilder
    func sendRequests() -> some View {
        List {
            ForEach(sendNotifications) { sended in
                NotificationView(
                    taskObject: sended,
                    textTask: sended.task.title,
                    sendFrom: sended.recipient
                )
            }
            .onDelete { indexSet in
                withAnimation {
                    for index in indexSet {
                        self.haptic.feedbackLight()
                        viewModelNotification.deleteNotification(notification: sendNotifications[index])
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
    }
}


struct SharedToDoListView_Preview: PreviewProvider {
    static var previews: some View {
        SharedToDoListView(userId: "dK6CG6dD7vUwHggvLO2jjTauQGA3")
    }
}
