import SwiftUI

struct EditEventItemView: View {
    
    @StateObject var viewModel = NewItemViewViewModel()
    @ObservedObject var viewModelEdit: EventViewViewModel
    @State private var showDescriptionView = false
    var haptic = HapticTrigger()
    @Binding var itemToSet: EventItem
    
    /// Variabili di stato locali per modificare i valori
    @State private var title: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var description: String = ""
    @State private var category: CategoryTask = .none
    
    init(itemToSet: Binding<EventItem>, viewModelEdit: EventViewViewModel) {
        self._itemToSet = itemToSet
        self._title = State(initialValue: itemToSet.wrappedValue.title)
        self._startDate = State(initialValue: Date(timeIntervalSince1970: itemToSet.wrappedValue.startDate))
        self._endDate = State(initialValue: Date(timeIntervalSince1970: itemToSet.wrappedValue.endDate))
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
                    Text("Start")
                    Spacer()
                    DatePicker(selection: $startDate, displayedComponents: [.date, .hourAndMinute]) {
                        EmptyView()
                    }
                    .fixedSize()
                }
                .frame(maxWidth: .infinity)
                
                HStack {
                    Image(systemName: "calendar")
                    Text("End")
                    Spacer()
                    DatePicker(selection: $endDate, displayedComponents: [.date, .hourAndMinute]) {
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
                    viewModelEdit.isOpenEditModal = false
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Update") {
                    self.haptic.feedbackMedium()
                    let updatedItem = EventItem(
                        id: itemToSet.id,
                        title: title,
                        startDate: startDate.timeIntervalSince1970,
                        endDate: endDate.timeIntervalSince1970,
                        createdDate: itemToSet.createdDate,
                        category: category,
                        description: InfoToDoItem(id: itemToSet.description.id, description: description) // Assicurati che questa conversione sia corretta
                    )
                    viewModelEdit.updateEvent(event: updatedItem)
                    viewModelEdit.isOpenEditModal = false
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

