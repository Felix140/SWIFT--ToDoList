import SwiftUI

struct EditItemTaskView: View {
    
    @StateObject var viewModel = NewItemViewViewModel()
    @ObservedObject var viewModelEdit: ToDoListViewViewModel /// ObservedObject per prendere la viewModel dal padre
    @Binding var toggleView: Bool
    @State private var showDescriptionView = false
    var haptic = HapticTrigger()
    @Binding var itemToSet: ToDoListItem
    
    /// Variabili di stato locali per modificare i valori
    @State private var title: String = ""
    @State private var dueDate: Date = Date()
    @State private var description: String = ""
    @State private var category: CategoryTask = .none
    
    /// Inizializza le variabili di stato con i valori dell'item da modificare
    init(toggleView: Binding<Bool>, itemToSet: Binding<ToDoListItem>, viewModelEdit: ToDoListViewViewModel) {
        self._toggleView = toggleView
        self._itemToSet = itemToSet
        self._title = State(initialValue: itemToSet.wrappedValue.title)
        self._dueDate = State(initialValue: Date(timeIntervalSince1970: itemToSet.wrappedValue.dueDate))
        self._description = State(initialValue: itemToSet.wrappedValue.description.description)
        self._category = State(initialValue: itemToSet.wrappedValue.category)
        
        self.viewModelEdit = viewModelEdit
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            //Component Title
            HStack {
                Spacer()
                Text("Modifica la tua Task")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top, 15)
                    .padding(.leading, 20)
                Spacer()
            }
            
            // Form
            Form {
                Section(header: Text("Titolo task")) {
                    TextField("Inserisci qui il titolo", text: $title)
                        .textInputAutocapitalization(.none)
                        .autocapitalization(.none)
                    
                    descriptionSelection()
                    
                }
                
                
                HStack {
                    Image(systemName: "calendar")
                    Text("Date")
                    Spacer()
                    DatePicker(selection: $dueDate, displayedComponents: [.date, .hourAndMinute]) {
                        EmptyView()
                    }
                    .fixedSize()
                }
                .frame(maxWidth: .infinity)
                
                
                Section(header: Text("Seleziona una categoria")) {
                    Picker("Categoria", selection: $category) {
                        ForEach(viewModel.categories, id: \.self) { category in
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
        .alert(isPresented: $viewModel.showAlert) {
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
                Button("Update") {
                    self.haptic.feedbackMedium()
                       let updatedItem = ToDoListItem(
                           id: itemToSet.id,
                           title: title,
                           dueDate: dueDate.timeIntervalSince1970,
                           createdDate: itemToSet.createdDate, // Usa l'originale createdDate
                           isDone: itemToSet.isDone, // Mantieni lo stato originale o permetti all'utente di modificarlo
                           category: category,
                           description: InfoToDoItem(id: itemToSet.description.id, description: description) // Assicurati che questa conversione sia corretta
                       )
                       viewModelEdit.updateTask(item: updatedItem)
                       toggleView = false
                }
            }
        }
    }
    
    // MARK: - Description
    @ViewBuilder
    func descriptionSelection() -> some View {
        
        Button(action: {
            self.haptic.feedbackMedium()
            self.showDescriptionView = true
        }) {
            if viewModel.description.isEmpty {
                Label("Modifica la descrizione", systemImage: "square.and.pencil")
            } else {
                Label("Modifica la descrizione", systemImage: "checkmark.square")
                    .foregroundColor(Color.green)
            }
        }
        .sheet(isPresented: $showDescriptionView) {
            NavigationView {
                InsertDescriptionView(
                    textDescription: $description,
                    isPresented: $showDescriptionView
                )
            }
        }
    }
}

//struct EditItemTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditItemTaskView(
//            toggleView: .constant(false),
//            itemToSet: .constant(<#ToDoListItem#>)
//        )
//    }
//}
