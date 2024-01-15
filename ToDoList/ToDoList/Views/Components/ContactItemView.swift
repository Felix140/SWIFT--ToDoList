import SwiftUI

struct ContactItemView: View {
    
    
    var username: String
    
    var body: some View {
        
        
        HStack {
            
            VStack(alignment: .leading, spacing: 4.0) {
                
                
                Text(username)
                    .font(.caption)
                
                Text("Esempiotesto 2")
                    .font(.footnote)
                    .foregroundColor(Color(.secondaryLabel))
            }
            
            Spacer()
            
            Button("Save") {
                
            }
        }
        
        
    }
}

struct ContactItemView_Previews: PreviewProvider {
    static var previews: some View {
        ContactItemView(
            username: "Nome Utente"
        )
    }
}
