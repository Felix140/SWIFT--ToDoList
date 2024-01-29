import SwiftUI

struct ContactItemView: View {
    
    
    @StateObject var viewModel = ContactsViewViewModel()
    var haptic = HapticTrigger()
    var user: UserContact
    var type: String
    
    var body: some View {
        
        switch type {
        case "searchSection":  searchContacts()
        case "savedSection":  savedContacts()
        default:
             Text("informations not available")
        }
        
    }
    
    
    @ViewBuilder
    func searchContacts() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4.0) {
                Text(user.name)
                    .font(.system(size: CGFloat(18)))
                Text(user.email)
                    .font(.footnote)
                    .foregroundColor(Color(.secondaryLabel))
            }
            Spacer()
            Button(action: {
                haptic.feedbackLight()
                viewModel.saveContact(user)
            }, label: {
                
                Image(systemName: user.isSaved ? "person.crop.circle.badge.checkmark" : "person.crop.circle.badge.plus")
                           .foregroundColor(user.isSaved ? .green : .blue)
                
            })
        }
    }
    
    
    @ViewBuilder
    func savedContacts() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4.0) {
                Text(user.name)
                    .font(.system(size: CGFloat(18)))
                Text(user.email)
                    .font(.footnote)
                    .foregroundColor(Color(.secondaryLabel))
            }
            Spacer()
            Image(systemName: "info.circle.fill")
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
