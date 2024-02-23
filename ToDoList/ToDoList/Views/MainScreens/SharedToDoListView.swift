import SwiftUI
import FirebaseFirestore

struct SharedToDoListView: View {
    
    @StateObject var viewModelToDoList: ToDoListViewViewModel
    @StateObject var viewModelNotification = NotificationViewViewModel()
    @FirestoreQuery var sendNotifications: [Notification]
    private var haptic = HapticTrigger()
    
    @State private var selectionPicker = 0
    @State private var showBanner: Bool = false
    
    init(userId: String) {
        self._viewModelToDoList = StateObject(wrappedValue: ToDoListViewViewModel(userId: userId))
        self._sendNotifications = FirestoreQuery(collectionPath: "users/\(userId)/sendNotifications/")
    }
    
    //MARK: - Bodys
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                
                // Banner
                if showBanner {
                    BannerView(testMessage: "Task Sended", colorBanner: .green, showBanner: $showBanner)
                }
                
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
        }
        .sheet(isPresented: $viewModelToDoList.isPresentingView) {
            NavigationStack {
                RequestNewItemView(toggleView: $viewModelToDoList.isPresentingView)
            }
        }
        
    }
    
    //MARK: - All_Notification
    
    @ViewBuilder
    func notifications() -> some View {
        List{
            ForEach(viewModelNotification.notifications) { notification in
                NotificationView(
                    isClicked: showBanner,
                    taskObject: notification,
                    textTask: notification.task.title,
                    sendFrom: notification.senderName,
                    onActionCompleted: { // Passa il callback
                        withAnimation {
                            showBanner = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showBanner = false
                            }
                        }
                    }
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
    
    //MARK: - Sended_Notification
    
    @ViewBuilder
    func sendRequests() -> some View {
        List {
            ForEach(sendNotifications) { sended in
                NotificationView(
                    isClicked: showBanner,
                    taskObject: sended,
                    textTask: sended.task.title,
                    sendFrom: sended.recipient,
                    onActionCompleted: { // Passa il callback
                        withAnimation {
                            showBanner = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                showBanner = false
                            }
                        }
                    }
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

//MARK: - PREVIEW

struct SharedToDoListView_Preview: PreviewProvider {
    static var previews: some View {
        SharedToDoListView(userId: "dK6CG6dD7vUwHggvLO2jjTauQGA3")
    }
}
