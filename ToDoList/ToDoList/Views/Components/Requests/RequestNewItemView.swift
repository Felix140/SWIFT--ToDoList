import SwiftUI
import FirebaseAuth

struct RequestNewItemView: View {
    
    @StateObject var viewModelNotification = NotificationViewViewModel()
    @StateObject var viewModelTest = ProfileViewViewModel()
    @StateObject var viewModelContacts = ContactsViewViewModel()
    @Binding var toggleView: Bool
    @State private var showDescriptionView = false
    @State var selectedUser: User? = nil //opzionale
    var haptic = HapticTrigger()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            //Component Title
            Text("Send Request")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 15)
                .padding(.leading, 20)
            
            // Form
            Form {
                Section(header: Text("Titolo task")) {
                    TextField("Inserisci qui il titolo", text: $viewModelNotification.title)
                        .textInputAutocapitalization(.none)
                        .autocapitalization(.none)
                    
                    descriptionSelection()
                    
                }
                
                Section(header: Text("Data della Task")) {
                    NavigationLink(destination: CalendarView(dateSelected: $viewModelNotification.date)) {
                        Label("Seleziona una data", systemImage: "calendar.badge.clock")
                    }
                }
                
                Section(header: Text("Seleziona una categoria")) {
                    Picker("Categoria", selection: $viewModelNotification.selectedCategory) {
                        ForEach(viewModelNotification.categories, id: \.self) { category in
                            Text(category.categoryName).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Send To")) {
                    Picker("Users", selection: $selectedUser) {
                        ForEach(viewModelContacts.privateContacts, id: \.self) { contact in
                            Text(contact.name).tag(contact as User?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onAppear {
                        if selectedUser == nil, let firstUser = viewModelContacts.privateContacts.first {
                            selectedUser = firstUser
                        }
                    }
                }
            }
            .frame(height: 440)
            .scrollDisabled(true)
            
            Spacer()
        }
        .alert(isPresented: $viewModelNotification.showAlert) {
            Alert(
                title: Text("Errore"),
                message: Text("Inserisci il campo testo o eventualmente il giorno in maniera corretta")
            )
        }
        .toolbar { /// aggiunge i bottoni di edit dello .sheet (modale)
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    toggleView = false
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    if let selectedUserId = selectedUser?.id,viewModelNotification.canSave() {
                        self.haptic.feedbackMedium()
                        viewModelNotification.sendRequest(sendTo: selectedUserId)
                        toggleView = false
                        
                    } else {
                        self.haptic.feedbackHeavy()
                        viewModelNotification.showAlert = true
                    }
                }
            }
        }
        .onAppear {
            viewModelContacts.fetchPrivateContacts()
        }
    }
    
    @ViewBuilder
    func descriptionSelection() -> some View {
        
        Button(action: {
            self.haptic.feedbackMedium()
            self.showDescriptionView = true
        }) {
            if viewModelNotification.description.isEmpty {
                Label("Aggiungi una descrizione", systemImage: "square.and.pencil")
            } else {
                Label("Aggiungi una descrizione", systemImage: "checkmark.square")
                    .foregroundColor(Color.green)
            }
        }
        .sheet(isPresented: $showDescriptionView) {
            NavigationView {
                InsertDescriptionView(
                    textDescription: $viewModelNotification.description,
                    isPresented: $showDescriptionView
                )
            }
        }
    }
}

//struct RequestNewItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        RequestNewItemView(
//            toggleView: .constant(false)
//        )
//    }
//}
