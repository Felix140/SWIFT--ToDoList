import SwiftUI

struct ToDoListView: View {
    
    @StateObject var viewModel = ToDoListViewViewModel()
    @State var isPresentingView = false

    
    var body: some View {
        NavigationView {
            VStack {
                
            }
            .navigationTitle("To Do List")
            .toolbar{
                Button(action: {
                    isPresentingView = true
                }) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add new Item")
            }
        }
        .sheet(isPresented: $isPresentingView) {
            NavigationStack {
                    NewItemView()
            }
        }
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
