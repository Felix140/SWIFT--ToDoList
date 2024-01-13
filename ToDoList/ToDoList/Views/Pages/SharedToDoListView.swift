import SwiftUI

struct SharedToDoListView: View {
    
    @StateObject var viewModel: ToDoListViewViewModel
    private var haptic = HapticTrigger()
    @State private var selectionPicker = 0
    
    init(userId: String) {
        self._viewModel = StateObject(wrappedValue: ToDoListViewViewModel(userId: userId))
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
                        viewModel.isPresentingView = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add new Item")
                }
            }
        }
        .sheet(isPresented: $viewModel.isPresentingView) {
            NavigationStack {
                RequestNewItemView(toggleView: $viewModel.isPresentingView)
            }
        }
        
    }
    
    func notifications() -> some View {
        List {
            
            ForEach(0..<10) { request in
                NotificationView()
            }
            
        }
        .listStyle(PlainListStyle())
    }
    
    func sendRequests() -> some View {
        List {
            
            ForEach(0..<10) { request in
                NotificationView()
            }
            
        }
        .listStyle(SidebarListStyle())
    }
    
    func doneListRequested() -> some View {
        List {
            
            ForEach(0..<10) { request in
                NotificationView()
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
