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
                Picker("menu", selection: $selectionPicker) {
                    Text("Notifications").tag(0)
                    Text("Requests").tag(1)
                    Text("Done").tag(2)
                }
                .pickerStyle(.segmented)
                
                Spacer()
                
                if selectionPicker == 0 {
                    
                }
                
                if selectionPicker == 1 {
                    
                }
                
                if selectionPicker == 2 {
                    
                }
                
            }
            .navigationTitle("Shared")
            .padding()
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
                NewItemView(
                    toggleView: $viewModel.isPresentingView
                )
            }
        }
        
    }
}


struct SharedToDoListView_Preview: PreviewProvider {
    static var previews: some View {
        SharedToDoListView(userId: "dK6CG6dD7vUwHggvLO2jjTauQGA3")
    }
}
