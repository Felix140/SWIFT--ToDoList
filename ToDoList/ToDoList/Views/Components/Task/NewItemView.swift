import SwiftUI

struct NewItemView: View {
    
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var toggleView: Bool
    @State private var showDescriptionView = false
    var haptic = HapticTrigger()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            //Component Title
            HStack {
                Spacer()
                Text("Inserisci la tua Task")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top, 15)
                    .padding(.leading, 20)
                Spacer()
            }
            
            // Form
            Form {
                Section(header: Text("Titolo task")) {
                    TextField("Inserisci qui il titolo", text: $viewModel.title)
                        .textInputAutocapitalization(.none)
                        .autocapitalization(.none)
                    
                    descriptionSelection()
                    
                }
                
                
                HStack {
                    Image(systemName: "calendar")
                    Text("Date")
                    Spacer()
                    DatePicker(selection: $viewModel.date, displayedComponents: [.date, .hourAndMinute]) {
                        EmptyView()
                    }
                    .fixedSize()
                }
                .frame(maxWidth: .infinity)
                
                
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
                        viewModel.save()
                        toggleView = false
                    } else {
                        self.haptic.feedbackHeavy()
                        viewModel.showAlert = true
                    }
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

struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView(
            toggleView: .constant(false)
        )
    }
}
