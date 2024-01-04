import SwiftUI

struct NewItemView: View {
    
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var toggleView: Bool
    @Binding var isOnPomodoro: Bool
    @State private var showDescriptionView = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            //Component Title
            Text("TooDoo Task")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 15)
                .padding(.leading, 20)
            
            // Form
            Form {
                Section(header: Text("Titolo task")) {
                    TextField("Inserisci qui il titolo", text: $viewModel.title)
                        .textInputAutocapitalization(.none)
                        .autocapitalization(.none)
                    
                    descriptionSelection()
                    
                }
                
                Section(header: Text("Data della Task")) {
                    NavigationLink(destination: CalendarView(dateSelected: $viewModel.date)) {
                        Label("Seleziona una data", systemImage: "calendar.badge.clock")
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
                
                Section(header: Text("Metodo pomodoro")){
                    Toggle(isOn: $isOnPomodoro) {
                        Label("Pomodoro Time", systemImage: "timer")
                    }
                }
            }
            .frame(height: 440)
            
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
                        viewModel.isOnPomodoro = isOnPomodoro
                        viewModel.save()
                        toggleView = false
                    } else {
                        viewModel.showAlert = true
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func descriptionSelection() -> some View {
        
        Button(action: {
            self.showDescriptionView = true
        }) {
            Label("Aggiungi una descrizione", systemImage: "pencil.and.list.clipboard")
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
            toggleView: .constant(false),
            isOnPomodoro: .constant(false)
        )
    }
}
