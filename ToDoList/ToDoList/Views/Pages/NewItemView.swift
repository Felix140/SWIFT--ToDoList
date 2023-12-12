import SwiftUI

struct NewItemView: View {
    
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var toggleView: Bool
    
    var body: some View {
        VStack {
            
            //Component Title
            Text("New Item")
                .font(.system(size: 30))
                .fontWeight(.bold)
                .padding(.top, 30)
            
            // Form
            Form {
                TextField("Item", text: $viewModel.title)
                    .textInputAutocapitalization(.none)
                    .autocapitalization(.none)
                
                DatePicker("Due date", selection: $viewModel.date)
                    .datePickerStyle(GraphicalDatePickerStyle())
            }
            .frame(height: 500)
            
            // Button
            ButtonFormView(textBtn: "Save", action: {
                
                if viewModel.canSave() {
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
        NewItemView(toggleView: .constant(false))
    }
}
