import SwiftUI

struct NewItemView: View {
    
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var toggleView: Bool
    @State private var showDescriptionView = false
    @State private var isEventItem: Bool = false
    var haptic = HapticTrigger()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // Form
            Form {
                Section(header: Text("Titolo task")) {
                    TextField("Inserisci qui il titolo", text: $viewModel.title)
                        .textInputAutocapitalization(.none)
                        .autocapitalization(.none)
                    
                    descriptionSelection()
                    
                }
                
                HStack {
                    Image(systemName: "square.fill.and.line.vertical.and.square.fill")
                    withAnimation(.easeInOut(duration: 1.3)) {
                        Toggle("Event", isOn: $isEventItem)
                    }
                }
                .frame(maxWidth: .infinity)
                
                
                
                Section {
                    // DATE 1
                    HStack {
                        Image(systemName: "calendar")
                        Text(isEventItem ? "Start Date" : "Date")
                        Spacer()
                        DatePicker(
                            selection: $viewModel.date,
                            displayedComponents: isEventItem ? [.date] : [.date, .hourAndMinute]) {
                                EmptyView()
                            }
                            .onChange(of: viewModel.date) { _ in
                                if !isEventItem {
                                    // Aggiorna date2 solo se non è selezionato come evento
                                    viewModel.date2 = viewModel.date
                                }
                            }
                            .fixedSize()
                    }
                    .frame(maxWidth: .infinity)
                    // DATE 2
                    if isEventItem {
                        HStack {
                            Image(systemName: "calendar")
                            Text("End Date")
                            Spacer()
                            DatePicker(selection: $viewModel.date2, displayedComponents: [.date]) {
                                EmptyView()
                            }
                            .fixedSize()
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                
                
                
                Section(header: Text("Seleziona una categoria")) {
                    Picker("Categoria", selection: $viewModel.selectedCategory) {
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
        .onChange(of: isEventItem) { newValue in
            /// Se isEventItem è false, allinea date2 con date
            if !newValue {
                viewModel.date2 = viewModel.date
            }
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
                Button("Done") {
                    if viewModel.canSave() {
                        self.haptic.feedbackMedium()
                        isEventItem ? viewModel.saveEvent() : viewModel.save()
                        toggleView = false
                    } else {
                        self.haptic.feedbackHeavy()
                        viewModel.showAlert = true
                    }
                }
                .foregroundColor(.green)
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
                Label("Aggiungi una descrizione", systemImage: "square.and.pencil")
            } else {
                Label("Aggiungi una descrizione", systemImage: "checkmark.square")
                    .foregroundColor(Color.green)
            }
        }
        .sheet(isPresented: $showDescriptionView) {
            NavigationView {
                InsertDescriptionView(
                    textDescription: $viewModel.description,
                    isPresented: $showDescriptionView
                )
            }
        }
    }
}

// MARK: - Preview
struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView(
            toggleView: .constant(false)
        )
    }
}
