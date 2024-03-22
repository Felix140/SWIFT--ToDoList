import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModelProfile = ProfileViewViewModel()
    var haptic = HapticTrigger()
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModelProfile.user {
                    profile(user: user)
                    dataProfile(user: user)
                } else {
                    Text("Loading profile...")
                }
                
                SettingsView(viewModel: viewModelProfile)
                
            }
            .navigationTitle("Profile")
        }
        .onAppear {
            viewModelProfile.fetchUser()
        }
    }
    
    
    @ViewBuilder
    func profile(user: User) -> some View {
        //Avatar
        VStack(alignment: .center) {
            ProfileImageView(profileImg: "turtlerock")
            
            VStack(alignment: .center) {
                Text(user.name)
                    .font(.title)
                    .bold()
                Text(user.email)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func dataProfile(user: User) -> some View {
        HStack {
            Image(systemName: "person.2")
            Text("\(Text("5").fontWeight(.bold)) friends")
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
