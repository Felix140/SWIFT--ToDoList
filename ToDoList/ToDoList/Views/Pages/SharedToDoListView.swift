import SwiftUI

struct SharedToDoListView: View {
    
    @StateObject var viewModelToDoList: ToDoListViewViewModel
    @StateObject var viewModelNotification = NotificationViewViewModel()
    private var haptic = HapticTrigger()
    @State private var selectionPicker = 0
    
    init(userId: String) {
        self._viewModelToDoList = StateObject(wrappedValue: ToDoListViewViewModel(userId: userId))
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
                        Image(systemName: "plus")
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
    
    func notifications() -> some View {
        List(viewModelNotification.notifications) { notification in
            NotificationView(textTask: notification.task.title, sendFrom: notification.sender)
        }
        .listStyle(PlainListStyle())
        .onAppear {
            viewModelNotification.fetchNotifications()
        }
    }
    
    func sendRequests() -> some View {
        List {
            
            
            
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
