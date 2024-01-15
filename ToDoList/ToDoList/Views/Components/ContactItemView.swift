import SwiftUI

struct ContactItemView: View {
    
    
    @StateObject var viewModel = ContactsViewViewModel()
    var user: User
    
    
    var body: some View {
        
        
        HStack {
            
            VStack(alignment: .leading, spacing: 4.0) {
                
                
                Text(user.name)
                    .font(.caption)
                
                Text(user.email)
                    .font(.footnote)
                    .foregroundColor(Color(.secondaryLabel))
            }
            
            Spacer()
            
            Button("Add") {
                viewModel.saveContact(user)
            }
        }
        
        
    }
}

//struct ContactItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContactItemView(
//            user: User(
//                id: "ciao",
//                name: "utente test", 
//                email: "utente@utente.com",
//                joined: ,
//                contacts: [])
//        )
//    }
//}
