import SwiftUI

struct ModalSpendingItemView: View {
    
    @ObservedObject var viewModel: FinanceViewViewModel
    
    
    init(viewModel: FinanceViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Form {
            
            Section(header: Text("Description")) {
                TextField("Inserisci qui il titolo", text: $viewModel.descriptionText)
                    .textInputAutocapitalization(.none)
                    .autocapitalization(.none)
                
            }
            
            Section(header: Text("Amount")) {
                TextField("Inserisci qui il titolo", value: $viewModel.amountInput,  formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .textInputAutocapitalization(.none)
                    .autocapitalization(.none)
            }
            
        
            
            Section {
                Button("Subtract") {
                    viewModel.spendingType = .subtract
                    viewModel.subtractSpending(value: viewModel.amountInput)
                    viewModel.isPresentingView = false
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            Section {
                Button("Add") {
                    viewModel.spendingType = .add
                    viewModel.addSpending(value: viewModel.amountInput)
                    viewModel.isPresentingView = false
                }
                .frame(minWidth: 0, maxWidth: .infinity)
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
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    viewModel.isPresentingView = false
                }
            }
        }
    }
}

#Preview {
    ModalSpendingItemView(viewModel: FinanceViewViewModel())
}
