import SwiftUI
import FirebaseFirestoreSwift

struct ContactsView: View {
    
    @State private var searchText: String = ""
    @FirestoreQuery var fetchedUser: [User]
    
    init() {
        self._fetchedUser = FirestoreQuery(collectionPath: "users/") // GET all users
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(searchText)
                    .navigationTitle("Contacts")
                
                
                listContacts()
            }
        }
        .searchable(text: $searchText, prompt: "Search")
    }
    
    
    func listContacts() -> some View {
        List {
            Section {
                ForEach(fetchedUser) {  user in
                    ContactItemView(username: user.name)
                }
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
