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
            HStack {
                Spacer()
                Text("Invia una Task")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top, 15)
                    .padding(.leading, 20)
                Spacer()
            }
            
            // Form
            Form {
                Section(header: Text("Send To")) {
                    conctactSelection()
                }
                
                Section(header: Text("Titolo task")) {
                    TextField("Inserisci qui il titolo", text: $viewModelNotification.title)
                        .textInputAutocapitalization(.none)
                        .autocapitalization(.none)
                    
                    descriptionSelection()
                    
                }
                
                HStack {
                    Image(systemName: "calendar")
                    Text("Date")
                    Spacer()
                    DatePicker(selection: $viewModelNotification.date, displayedComponents: [.date, .hourAndMinute]) {
                        EmptyView()
                    }
                    .fixedSize()
                }
                .frame(maxWidth: .infinity)
                
                Section(header: Text("Seleziona una categoria")) {
                    Picker("Categoria", selection: $viewModelNotification.selectedCategory) {
                        ForEach(viewModelNotification.categories, id: \.self) { category in
                            Text(category.categoryName).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            .frame(height: 440)
            .scrollDisabled(true)
            
            Spacer()
        }
        .alert(isPresented: $viewModelNotification.showAlert) {
            Alert(
                title: Text("Errore"),
                message: Text("Inserisci il titolo e/o il contatto correttamente")
            )
        }
        .toolbar { /// aggiunge i bottoni di edit dello .sheet (modale)
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    toggleView = false
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Send") {
                    if selectedUser == nil {
                        self.haptic.feedbackHeavy()
                        viewModelNotification.showAlert = true
                    } else if viewModelNotification.canSave() {
                        if let selectedUserId = selectedUser?.id {
                            self.haptic.feedbackMedium()
                            viewModelNotification.sendRequest(sendTo: selectedUserId)
                            toggleView = false
                        }
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
    
    @ViewBuilder
    func conctactSelection() -> some View {
        if selectedUser == nil {
            HStack {
                Image(systemName: "person")
                Picker("Select the user", selection: $selectedUser) {
                    Text("List contacts").tag(nil as User?)
                    ForEach(viewModelContacts.privateContacts, id: \.self) { contact in
                        Text(contact.name).tag(contact as User?)
                    }
                }
                .pickerStyle(.navigationLink)
            }
        } else {
            HStack {
                Image(systemName: "person.fill")
                Picker("Select the user", selection: $selectedUser) {
                    Text("List contacts").tag(nil as User?)
                    ForEach(viewModelContacts.privateContacts, id: \.self) { contact in
                        Text(contact.name).tag(contact as User?)
                            .fontWeight(.bold)
                    }
                }
                .pickerStyle(.navigationLink)
            }
            .foregroundColor(Color.green)
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
