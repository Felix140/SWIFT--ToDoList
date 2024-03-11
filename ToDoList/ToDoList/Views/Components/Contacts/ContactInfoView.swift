import SwiftUI

struct ContactInfoView: View {
    
    let userData: User
    
    var body: some View {
        Text("\(userData.name)")
        Text("\(userData.email)")
    }
}

#Preview {
    ContactInfoView(userData:
                        User(
                            id: "1234",
                            name: "Name",
                            email: "Email",
                            joined: Date().timeIntervalSince1970)
    )
}
