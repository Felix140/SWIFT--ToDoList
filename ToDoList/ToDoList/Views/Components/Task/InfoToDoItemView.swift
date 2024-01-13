import SwiftUI

struct InfoToDoItemView: View {
    
    var descriptionText: String
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                
                Text("Descrizione")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Divider()
                
                Text(descriptionText)
                
                Spacer()
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Image(systemName: "info.circle")
            }
        }
    }
}

struct InfoToDoItemView_Preview: PreviewProvider {
    static var previews: some View {
        InfoToDoItemView(descriptionText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
    }
}
