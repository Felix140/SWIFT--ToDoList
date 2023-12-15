import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                //Avatar
                ProfileImageView()
                    .padding(.top, 50)
                
                //Info: Name, Email, Member Since
                VStack(alignment: .leading){
                    HStack {
                        Text("Name: ")
                        Text("Felix")
                    }
                    HStack {
                        Text("Email: ")
                        Text("Felix")
                    }
                    HStack {
                        Text("Iscritto il: ")
                        Text("Felix")
                    }
                }
                .padding(.top, 50)
                
                Spacer()
                
                // SignOut
                ButtonFormView(textBtn: "Log Out", action: { viewModel.logOut() })
                    .frame(width: 300)
                Spacer()
            }
            .navigationTitle("Profile")

        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
