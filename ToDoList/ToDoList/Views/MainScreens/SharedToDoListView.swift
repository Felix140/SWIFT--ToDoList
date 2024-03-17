import SwiftUI
import FirebaseFirestore

struct SharedToDoListView: View {
    
    @StateObject var viewModelToDoList: ToDoListViewViewModel
    @ObservedObject var viewModelNotification : NotificationViewViewModel
    @FirestoreQuery var sendNotifications: [TaskNotification]
    private var haptic = HapticTrigger()
    
    @State private var selectionPicker = 0
    @State private var showBanner: Bool = false
    @State private var bannerColor: Color = .green
    
    init(userId: String, viewModelNotification: NotificationViewViewModel) {
        self._viewModelToDoList = StateObject(wrappedValue: ToDoListViewViewModel(userId: userId))
        self._sendNotifications = FirestoreQuery(collectionPath: "users/\(userId)/sendNotifications/")
        self.viewModelNotification = viewModelNotification
    }
    
    //MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                
                // Banner
                if showBanner {
                    BannerView(
                        testMessage: bannerColor == .green ? "Accepted" : "Rejected",
                        colorBanner: bannerColor,
                        showBanner: $showBanner)
                }
                
                VStack {
                    Divider()
                    HStack {
                        Picker("menu", selection: $selectionPicker) {
                            Text("Task Requests").tag(0)
                            Text("Friend Requests").tag(1)
                            Text("Send Requests").tag(2)
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.horizontal, 10)
                    
                    Spacer()
                    
                    switch selectionPicker {
                    case 0: notifications()
                    case 1: friendRequests()
                    case 2: sendRequests()
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
        .onChange(of: viewModelNotification.isShowingBadge) { _ in
            viewModelNotification.isShowingBadge = false
        }
    }
    
    //MARK: - All_Notification
    
    @ViewBuilder
    func notifications() -> some View {
        List{
            ForEach(viewModelNotification.notifications) { notification in
                NotificationView(
                    isClicked: showBanner,
                    isShowingButtons: true,
                    isSendNotification: false,
                    taskObject: notification,
                    textTask: notification.task.title,
                    sendFrom: notification.sender.name,
                    onActionCompleted: {  actionType in// Passa il callback
                        withAnimation {
                            bannerColor = actionType == .accept ? .green : .red
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
                    isShowingButtons: false,
                    isSendNotification: true,
                    taskObject: sended,
                    textTask: sended.task.title,
                    sendFrom: sended.sender.name,
                    onActionCompleted: { _ in /// Passa il callback
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
                        viewModelNotification.deleteSendRequest(sendNotification: sendNotifications[index])
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    //MARK: - Friend_Requests
    
    @ViewBuilder
    func friendRequests() -> some View {
        List{
            ForEach(viewModelNotification.friendRequests) { friendRequest in
                FriendRequestView(
                    friendRequestObject: friendRequest,
                    sendFrom: friendRequest.sender.name,
                    onActionCompleted: {  actionType in// Passa il callback
                        withAnimation {
                            bannerColor = actionType == .acceptFriend ? .green : .red
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
        }
        .listStyle(PlainListStyle())
        .onAppear {
            viewModelNotification.fetchFriendRequestReceived()
        }
    }
}

//MARK: - PREVIEW

struct SharedToDoListView_Preview: PreviewProvider {
    static var previews: some View {
        SharedToDoListView(userId: "dK6CG6dD7vUwHggvLO2jjTauQGA3", viewModelNotification: NotificationViewViewModel())
    }
}
