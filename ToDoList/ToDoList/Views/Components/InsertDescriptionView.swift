import SwiftUI

struct InsertDescriptionView: View {
    
    
    @Binding var textDescription: String
    
    var body: some View {
        VStack {
            Text("Inserisci qui la descrizione")
                .font(.title2)
                .fontWeight(.bold)
            
            TextEditor(text: $textDescription)
                .cornerRadius(10)
                .border(Color.gray, width: 1)
                .frame(height: UIScreen.main.bounds.height / 2)
                .padding()
            
            Spacer()
        }
            
    }
}

struct InsertDescription_Preview: PreviewProvider {
    static var previews: some View {
        InsertDescriptionView(textDescription: .constant("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."))
    }
}
