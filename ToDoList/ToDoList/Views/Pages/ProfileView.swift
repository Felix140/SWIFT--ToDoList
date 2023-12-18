import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                
                if let user = viewModel.user {
                    //Avatar
                    ProfileImageView()
                        .padding(.top, 50)
                    
                    //Info: Name, Email, Member Since
                    VStack(alignment: .leading){
                        HStack {
                            Text("Name: ")
                                .bold()
                            Text(user.name)
                        }
                        HStack {
                            Text("Email: ")
                                .bold()
                            Text(user.email)
                        }
                        HStack {
                            Text("Iscritto il: ")
                                .bold()
                            Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
                        }
                    }
                    .padding(.top, 50)
                    
                    Spacer()
                } else {
                    Text("Loading profile...")
                }
                
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
