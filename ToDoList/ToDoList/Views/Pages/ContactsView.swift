import SwiftUI
import FirebaseFirestoreSwift

struct ContactsView: View {
    
    @State private var searchText: String = ""
    @StateObject var viewModel = ContactsViewViewModel()
    @FirestoreQuery var fetchedUser: [User]
    @State var selectedPicker: Int = 0
    
    init() {
        self._fetchedUser = FirestoreQuery(collectionPath: "users/") // GET all users
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                                
                HStack {
                    if #available(iOS 17.0, *) {
                        Picker("TooDoo List", selection: $selectedPicker) {
                            Text("All Users").tag(0)
                            Text("Saved").tag(1)
                        }
                        .pickerStyle(.palette)
                    } else {
                        
                        Picker("TooDoo List", selection: $selectedPicker) {
                            Text("All Users").tag(0)
                            Text("Saved").tag(1)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                }
                .padding(.horizontal, 10)
                
                
                if selectedPicker == 0 {
                    listContacts()
                }
                
                if selectedPicker == 1 {
                    saveContacts()
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search")
        .onAppear {
            viewModel.fetchPrivateContacts()
        }
    }
    
    
    func listContacts() -> some View {
        List {
            Section {
                if searchText.count >= 1 {  // Modifica qui
                    ForEach(fetchedUser.filter { user in
                        user.name.lowercased().contains(searchText.lowercased())
                    }) { user in
                        ContactItemView(user: user)
                    }
                } 
            }
        }
        .listStyle(PlainListStyle())
    }
    
    
    
    func saveContacts()-> some View {
        List {
            ForEach(viewModel.privateContacts) { privateUser in
                ContactItemView(user: privateUser)
            }
        }
        .listStyle(PlainListStyle())
    }
    
}

struct ContactsView_Preview: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}
