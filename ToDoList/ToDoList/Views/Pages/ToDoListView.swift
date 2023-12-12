import SwiftUI
import FirebaseFirestoreSwift

struct ToDoListView: View {
    
    @StateObject var viewModel = ToDoListViewViewModel()
    @FirestoreQuery var fetchedItems: [ToDoListItem]

    init(userId: String) {
        /// users/<id>/todos/<entries>
        self._fetchedItems = FirestoreQuery(
            collectionPath: "users/\(userId)/ToDos/") // GET query
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(fetchedItems) { fetched in
                    ToDoListItemView(listItem: fetched)
                        .swipeActions {
                            Button("Delete") {
                                viewModel.delete(id: fetched.id)
                            }
                        }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("To Do List")
            .toolbar{
                Button(action: {
                    viewModel.isPresentingView = true
                }) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add new Item")
            }
        }
        .sheet(isPresented: $viewModel.isPresentingView) {
            NavigationStack {
                NewItemView(toggleView: $viewModel.isPresentingView)
            }
        }
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView(userId: "dK6CG6dD7vUwHggvLO2jjTauQGA3")
    }
}
