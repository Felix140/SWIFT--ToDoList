import SwiftUI

struct SharedToDoListView: View {
    
    @StateObject var viewModel: ToDoListViewViewModel
    private var haptic = HapticTrigger()
    
    init(userId: String) {
        self._viewModel = StateObject(wrappedValue: ToDoListViewViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Shared View")
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
