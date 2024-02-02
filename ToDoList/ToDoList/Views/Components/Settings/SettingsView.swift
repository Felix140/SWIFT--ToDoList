import SwiftUI


struct SettingsView: View {
    
    var viewModel: ProfileViewViewModel
    var haptic = HapticTrigger()
    
    var body: some View {
        
        VStack(alignment: .leading){
            Form {
                Section {
                    NavigationLink(
                        destination: EditPrivateInfoView(dataUserviewModel: viewModel), label: {
                        Label("Modifica Profilo", systemImage: "pencil")
                    })
                }
                
                Section {
                    NavigationLink(destination: {}, label: {
                        Label("Theme", systemImage: "paintpalette")
                    })
                }
                Section {
                    NavigationLink(destination: {}, label: {
                        Label("Assistenza", systemImage: "questionmark.circle")
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
        .navigationTitle("Settings")
    }
}

struct SettingsView_Preview: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: ProfileViewViewModel())
    }
}
