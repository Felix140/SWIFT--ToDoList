import SwiftUI

struct EditItemTaskView: View {
    
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var toggleView: Bool
    @State private var showDescriptionView = false
    var haptic = HapticTrigger()
    @Binding var itemToSet: ToDoListItem
    
    // Variabili di stato locali per modificare i valori
    @State private var title: String = ""
    @State private var dueDate: Date = Date()
    @State private var description: String = ""
    
    // Inizializza le variabili di stato con i valori dell'item da modificare
    init(toggleView: Binding<Bool>, itemToSet: Binding<ToDoListItem>) {
        self._toggleView = toggleView
        self._itemToSet = itemToSet
        self._title = State(initialValue: itemToSet.wrappedValue.title)
        self._dueDate = State(initialValue: Date(timeIntervalSince1970: itemToSet.wrappedValue.dueDate))
        self._description = State(initialValue: itemToSet.wrappedValue.description.description)
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
                
                
                //                Section(header: Text("Seleziona una categoria")) {
                //                    Picker("Categoria", selection: $itemToSet.selectedCategory) {
                //                        ForEach(viewModel.categories, id: \.self) { category in
                //                            Text(category.categoryName).tag(category)
                //                        }
                //                    }
                //                    .pickerStyle(MenuPickerStyle())
                //                }
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
                    if viewModel.canSave() {
                        self.haptic.feedbackMedium()
                        viewModel.save()
                        toggleView = false
                    } else {
                        self.haptic.feedbackHeavy()
                        viewModel.showAlert = true
                    }
                }
            }
        }
        .onAppear {
            // Aggiorna le variabili di stato con i valori correnti di itemToSet
            self.title = self.itemToSet.title
            self.dueDate = Date(timeIntervalSince1970: self.itemToSet.dueDate)
            self.description = self.itemToSet.description.description
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
