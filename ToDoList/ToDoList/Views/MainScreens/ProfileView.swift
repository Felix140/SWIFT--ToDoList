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
                
                Spacer()
                    .frame(height: 100)
            }
            
        }
        .onAppear {
            viewModelProfile.fetchUser()
        }
    }
    
    
    @ViewBuilder
    func profile(user: User) -> some View {
        //Avatar
        HStack(alignment: .center) {
            ProfileImageView(profileImg: "turtlerock")
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.title)
                    .bold()
                Text(user.email)
            }
            .padding(.leading, 10)
            
            Spacer()
        }
        .padding(.top, UIScreen.main.bounds.height / 20)
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
