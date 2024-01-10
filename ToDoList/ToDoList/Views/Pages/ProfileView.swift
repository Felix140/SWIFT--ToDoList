import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewViewModel()
    var haptic = HapticTrigger()
    
    var body: some View {
        NavigationView {
            VStack {
                
                if let user = viewModel.user {
                    profile(user: user)
                } else {
                    Text("Loading profile...")
                }
                
                
                // SignOut
                ButtonFormView(textBtn: "Log Out", action: {
                    self.haptic.feedbackHeavy()
                    viewModel.logOut()
                })
                .frame(width: UIScreen.main.bounds.width / 1.1)
                
                Spacer()
                    .frame(height: 100)
            }
            .navigationTitle("Profile")
            .toolbar {
                // Pulsante che porta a SettingsView
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                }
                .accessibilityLabel("Impostazioni")
            }
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }
    
    
    @ViewBuilder
    func profile(user: User) -> some View {
        //Avatar
        ProfileImageView(profileImg: "turtlerock")
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
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
