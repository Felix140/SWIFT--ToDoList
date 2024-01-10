import SwiftUI

struct InsertDescriptionView: View {
    
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var textDescription: String
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Descrizione")
                .font(.title2)
                .fontWeight(.bold)
                .onTapGesture {
                    hideKeyboard() /// nascondi la tastiera se clicca sul titolo
                }
            
            Divider()
            
            Spacer()
                .frame(height: 25)
                .onTapGesture {
                    hideKeyboard() /// nascondi la tastiera se clicca nello spazio vuoto
                }
            
            ZStack(alignment: .topLeading) {
                
                if textDescription.isEmpty {
                    Text("Inserisci la descrizione qui...")
                        .foregroundColor(Color.gray)
                        .padding(.top, 15)
                        .padding(.leading, 16)
                }
                
                TextEditor(text: $textDescription)
                    .opacity(textDescription.isEmpty ? 0.25 : 1)
                    .padding(.top, 8)
                    .padding(.leading, 10)
                
            }
            .frame(height: 200)

            
            Spacer()
                .onTapGesture {
                    hideKeyboard() /// nascondi la tastiera se clicca nello spazio vuoto
                }
            
        }
        .padding(.horizontal, 20)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Errore"),
                message: Text("Inserisci la descrizione")
            )
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Aggiungi") {
                    viewModel.description = textDescription
                    
                    if viewModel.canAddDescription() {
                        isPresented = false
                    } else {
                        viewModel.showAlert = true
                    }
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    isPresented = false
                    textDescription = ""
                }
            }
        }
    }
    
    
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct InsertDescription_Preview: PreviewProvider {
    static var previews: some View {
        InsertDescriptionView(
            textDescription: .constant(""),
            isPresented: .constant(true))
    }
}
