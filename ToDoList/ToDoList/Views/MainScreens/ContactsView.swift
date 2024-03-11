import SwiftUI
import FirebaseFirestoreSwift

struct ContactsView: View {
    
    @State private var searchText: String = ""
    @StateObject var viewModel = ContactsViewViewModel()
    @State private var selectedPicker: Int = 0
    
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
                
                
                switch selectedPicker {
                case 0: listContacts()
                case 1: saveContacts()
                default:
                    Text("Error, informations not available")
                }
                
            }
            .navigationTitle("Contacts")
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
                    ForEach(viewModel.allUsers.filter { user in
                        user.name.lowercased().contains(searchText.lowercased())
                    }) { user in
                        ContactItemView(
                            viewModel: viewModel,
                            user: user,
                            type: "searchSection")
                        .sheet(isPresented: $viewModel.isShowingInfoUser, content: {
                            NavigationStack {
                                if let selection = viewModel.userSelected {
                                    ContactInfoView(userData: selection)
                                }
                            }
                        })
                    }
                } 
            }
        }
        .listStyle(PlainListStyle())
    }
    
    
    
    func saveContacts()-> some View {
        List {
            ForEach(viewModel.privateContacts) { privateUser in
                ContactItemView(
                    viewModel: viewModel,
                    user: privateUser,
                    type: "savedSection")
            }
            .onDelete { indexSet in
                withAnimation {
                    // Esegui l'eliminazione degli elementi qui, avvolta da withAnimation
                    for index in indexSet {
                        viewModel.deleteContact(userContactId: viewModel.privateContacts[index].id)
                    }
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
