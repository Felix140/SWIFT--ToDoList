import SwiftUI

struct ContactItemView: View {
    
    /// ObservedObject viewModel: Un riferimento condiviso a ContactsViewViewModel che permette a questa vista di reagire ai cambiamenti di stato come aggiornamenti della lista di contatti, mantenendo sincronizzati i dati visualizzati con il modello sottostante.
    @ObservedObject var viewModel: ContactsViewViewModel
    @StateObject var viewModelNotification = NotificationViewViewModel()
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
            
            Grid(alignment: .center, horizontalSpacing: 20) {
                GridRow {
                    buttonInfo()
                    buttonSendRequest()
                }
            }
            .padding()
            
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
                .font(.system(size: 22))
        }
    }
    
    func buttonInfo() -> some View {
        Image(systemName: "info.circle.fill")
            .foregroundColor(Color(.secondaryLabel))
            .font(.system(size: 22))
            .onTapGesture {
                haptic.feedbackLight()
                viewModel.userSelected = user
                viewModel.isShowingInfoUser = true
            }
    }
    
    func buttonSendRequest() -> some View {
        Image(systemName: user.isSaved ? "person.badge.clock" : "person.crop.circle.badge.plus")
            .foregroundColor(user.isSaved ? .green : .blue)
            .font(.system(size: 22))
            .onTapGesture {
                haptic.feedbackLight()
                viewModelNotification.sendFriendRequest(recipient: user)
            }
    }
}

struct ContactItemView_Previews: PreviewProvider {
    static var previews: some View {
        ContactItemView(
            viewModel: ContactsViewViewModel(),
            user: UserContact(
                id: "qwer",
                name: "qwer",
                email: "qwer",
                joined: Date().timeIntervalSince1970,
                isSaved: false),
            type: "searchSection")
        
    }
}
