import SwiftUI

struct InfoToDoItemView: View {
    
    @Binding var descriptionText: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Descrizione")
                .font(.title2)
                .fontWeight(.bold)
            
            Divider()
            
            Text(descriptionText)
            
            Spacer()
        }
        .padding()
        .onDisappear(perform: {
            descriptionText = ""
        })
    }
}

struct InfoToDoItemView_Preview: PreviewProvider {
    static var previews: some View {
        InfoToDoItemView(descriptionText: .constant("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."))
    }
}
