import SwiftUI


struct SettingsView: View {
    
    var viewModel: ProfileViewViewModel
    var haptic = HapticTrigger()
    
    var body: some View {
        
        VStack(alignment: .leading){
            Form {
                
                Section {
                    NavigationLink(
                        destination: {}, label: {
                        Label("Friends", systemImage: "person.2")
                    })
                    NavigationLink(
                        destination: EditPrivateInfoView(dataUserviewModel: viewModel), label: {
                        Label("Edit Profile", systemImage: "pencil")
                    })
                    NavigationLink(destination: {}, label: {
                        Label("Theme", systemImage: "paintpalette")
                    })
                    NavigationLink(destination: {}, label: {
                        Label("Support", systemImage: "questionmark.circle")
                    })
                    NavigationLink(destination: {}, label: {
                        Label("Privacy Policy", systemImage: "hand.raised.circle")
                    })
                }

                Section {
                    HStack {
                        Button(action: {
                            self.haptic.feedbackHeavy()
                            viewModel.logOut()
                        }, label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        })
                        
                        Text("Log Out")
                            .padding(.leading, 10)
                    }
                }
            }
            .scrollDisabled(true)
            Spacer()
            
        }
    }
}

struct SettingsView_Preview: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: ProfileViewViewModel())
    }
}
