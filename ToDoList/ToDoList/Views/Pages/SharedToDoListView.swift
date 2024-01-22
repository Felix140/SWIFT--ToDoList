import SwiftUI
import FirebaseFirestore

struct SharedToDoListView: View {
    
    @StateObject var viewModelToDoList: ToDoListViewViewModel
    @StateObject var viewModelNotification = NotificationViewViewModel()
    @FirestoreQuery var sendNotifications: [Notification]
    private var haptic = HapticTrigger()
    @State private var selectionPicker = 0
    
    @State private var alertTest: Bool = false
    
    init(userId: String) {
        self._viewModelToDoList = StateObject(wrappedValue: ToDoListViewViewModel(userId: userId))
        self._sendNotifications = FirestoreQuery(collectionPath: "users/\(userId)/sendNotifications/")
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                Divider()
                
                HStack {
                    Picker("menu", selection: $selectionPicker) {
                        Text("Notifications").tag(0)
                        Text("Send Requests").tag(1)
                        Text("Done").tag(2)
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal, 10)
                
                Spacer()
                
                if selectionPicker == 0 {
                    notifications()
                }
                
                if selectionPicker == 1 {
                    sendRequests()
                }
                
                if selectionPicker == 2 {
                    doneListRequested()
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
            .alert(isPresented: $alertTest) {
                Alert(
                    title: Text("Test"),
                    message: Text("Bottone cliccato: ")
                )
            }
        }
        .sheet(isPresented: $viewModelToDoList.isPresentingView) {
            NavigationStack {
                RequestNewItemView(toggleView: $viewModelToDoList.isPresentingView)
            }
        }
        
    }
    
    func notifications() -> some View {
        List{
            ForEach(viewModelNotification.notifications) { notification in
                NotificationView(
                    textTask: notification.task.title,
                    sendFrom: notification.senderName,
                    alert: $alertTest
                )
            }
            .swipeActions {
                Button("Delete") {
                    /// Elimina notifica
                }
                .tint(.red)
            }
        }
        .listStyle(PlainListStyle())
        .onAppear {
            viewModelNotification.fetchNotifications()
        }
    }
    
    func sendRequests() -> some View {
        List {
            ForEach(sendNotifications) { sended in
                NotificationView(
                    textTask: sended.task.title,
                    sendFrom: sended.recipient,
                    alert: $alertTest)
            }
        }
        .listStyle(SidebarListStyle())
    }
    
    func doneListRequested() -> some View {
        List {
            
            
            
        }
        .listStyle(SidebarListStyle())
    }
}


struct SharedToDoListView_Preview: PreviewProvider {
    static var previews: some View {
        SharedToDoListView(userId: "dK6CG6dD7vUwHggvLO2jjTauQGA3")
    }
}
