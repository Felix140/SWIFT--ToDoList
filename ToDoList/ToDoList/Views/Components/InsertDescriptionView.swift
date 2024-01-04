import SwiftUI

struct InsertDescriptionView: View {
    
    
    @Binding var textDescription: String
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Inserisci qui la descrizione")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .padding(.leading, 20)
                
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
                .frame(height: UIScreen.main.bounds.height / 3)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary, lineWidth: 0.6)
                )
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Aggiungi") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

struct InsertDescription_Preview: PreviewProvider {
    static var previews: some View {
        InsertDescriptionView(
            textDescription: .constant(""),
            isPresented: .constant(true))
    }
}
