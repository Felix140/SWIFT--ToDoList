import SwiftUI

struct ModalSpendingItemView: View {
    
    @State var description = "descrizione"
    @State var amount = 10
    
    var body: some View {
        Form {
            
            Section(header: Text("Description")) {
                TextField("Inserisci qui il titolo", text: $description)
                    .textInputAutocapitalization(.none)
                    .autocapitalization(.none)
                
            }
            Section {
                
            }
            Section(header: Text("Amount")) {
                TextField("Inserisci qui il titolo", value: $amount,  formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .textInputAutocapitalization(.none)
                    .autocapitalization(.none)
                
            }
            
            //            Section(header: Text("Seleziona una categoria")) {
            //                Picker("Categoria", selection: $viewModel.selectedCategory) {
            //                    ForEach(viewModel.categories, id: \.self) { category in
            //                        Text(category.categoryName).tag(category)
            //                    }
            //                }
            //                .pickerStyle(MenuPickerStyle())
            //            }
            
        }
        .toolbar { /// aggiunge i bottoni di edit dello .sheet (modale)
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                }
                .foregroundColor(.green)
            }
        }
    }
}

#Preview {
    ModalSpendingItemView()
}
