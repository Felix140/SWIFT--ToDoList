import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModelProfile = ProfileViewViewModel()
    var haptic = HapticTrigger()
    
    var body: some View {
        NavigationView {
            VStack {
                
                if let user = viewModelProfile.user {
                    profile(user: user)
                } else {
                    Text("Loading profile...")
                }
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Theme.redGradient.gradient)
                            .frame(width: 150, height: 150)
                        Circle()
                            .strokeBorder(lineWidth: 10)
                            .frame(width: 120, height: 120)
                            .foregroundColor(.green)
                            .overlay(content: {
                                Text("10")
                                    .font(.title)
                            })
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Theme.redGradient.gradient)
                            .frame(width: 150, height: 150)
                        Circle()
                            .strokeBorder(lineWidth: 10)
                            .frame(width: 120, height: 120)
                            .foregroundColor(.green)
                            .overlay(content: {
                                Text("10")
                                    .foregroundColor(.primary)
                                    .font(.title)
                            })
                        
                    }
                }
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Theme.redGradient.gradient)
                            .frame(width: 150, height: 150)
                        Circle()
                            .strokeBorder(lineWidth: 10)
                            .frame(width: 120, height: 120)
                            .foregroundColor(.green)
                            .overlay(content: {
                                Text("10")
                                    .font(.title)
                            })
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Theme.redGradient.gradient)
                            .frame(width: 150, height: 150)
                        Circle()
                            .strokeBorder(lineWidth: 10)
                            .frame(width: 120, height: 120)
                            .foregroundColor(.green)
                            .overlay(content: {
                                Text("10")
                                    .foregroundColor(.primary)
                                    .font(.title)
                            })
                        
                    }
                }
                
                Spacer()
                    .frame(height: 100)
            }
            .navigationTitle("Profile")
            .toolbar {
                // Pulsante che porta a SettingsView
                NavigationLink(destination: SettingsView(viewModel: viewModelProfile)) {
                    Image(systemName: "gear")
                }
                .accessibilityLabel("Impostazioni")
            }
        }
        .onAppear {
            viewModelProfile.fetchUser()
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
