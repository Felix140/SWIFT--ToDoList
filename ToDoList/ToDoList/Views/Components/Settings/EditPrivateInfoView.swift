import SwiftUI

struct EditPrivateInfoView: View {
    
    var dataUserviewModel = ProfileViewViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(dataUserviewModel.user?.name ?? "Name not found")
            Text(dataUserviewModel.user?.name ?? "Email not found")
            Text("***********")
        }
    }
}

#Preview {
    EditPrivateInfoView()
}
