import SwiftUI
import FirebaseFirestoreSwift

struct ToDoListView: View {
    
    /// @StateObject var viewModel = ToDoListViewViewModel()
    /// anziche creare uno StateObject come qui sopra, inizializziamo l'oggetto in init() per
    /// passargli il parametro dello userId, inizializzato a sua volta nell'init() di "ToDoListViewViewModel()"
    @StateObject var viewModel: ToDoListViewViewModel
    @FirestoreQuery var fetchedItems: [ToDoListItem]

    
    init(userId: String) {
        
        /// users/<id>/todos/<entries>
        self._fetchedItems = FirestoreQuery(
            collectionPath: "users/\(userId)/ToDos/") // GET query
        
        /// inizializzo qui sotto viewModel come StateObject
        self._viewModel = StateObject(wrappedValue: ToDoListViewViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(fetchedItems) { fetched in
                    ToDoListItemView(listItem: fetched)
                        .swipeActions {
                            Button("Delete") {
                                viewModel.delete(idItem: fetched.id)
                            }
                            .tint(.red)
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
