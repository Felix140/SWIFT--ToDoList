import SwiftUI

struct NewItemView: View {
    
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var toggleView: Bool
    @Binding var isOnPomodoro: Bool
    
    var body: some View {
        VStack {
            
            //Component Title
            Text("TooDoo Task")
                .font(.system(size: 30))
                .fontWeight(.bold)
                .padding(.top, 30)
            
            // Form
            Form {
                Section(header: Text("Titolo task")) {
                    TextField("Inserisci qui il titolo", text: $viewModel.title)
                        .textInputAutocapitalization(.none)
                        .autocapitalization(.none)
                }
                
                Section(header: Text("Data della Task")) {
                    NavigationLink(destination: CalendarView(dateSelected: $viewModel.date)) {
                        Label("Seleziona una data", systemImage: "calendar.badge.clock")
                    }
                }
                
                Section(header: Text("Seleziona una categoria")){
                    TextField("Inserisci qui la categoria", text: $viewModel.category)
                        .textInputAutocapitalization(.none)
                        .autocapitalization(.none)
                }
                
                Section(header: Text("Metodo pomodoro")){
                    Toggle(isOn: $isOnPomodoro) {
                        Label("Pomodoro Time", systemImage: "timer")
                    }
                }
            }
            .frame(height: 400)
            
            // Button
            ButtonFormView(textBtn: "Save", action: {
                
                if viewModel.canSave() {
                    viewModel.isOnPomodoro = isOnPomodoro
                    viewModel.save()
                    toggleView = false
                } else {
                    viewModel.showAlert = true
                }
                
            })
            .padding([.trailing, .leading, .top], 30)
            
            Spacer()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Errore"),
                message: Text("Inserisci il campo testo o eventualmente il giorno in maniera corretta")
            )
        }
    }
}

struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView(toggleView: .constant(false), isOnPomodoro: .constant(false))
    }
}
