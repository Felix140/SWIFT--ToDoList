import SwiftUI


struct SettingsView: View {
    
    @StateObject var viewModel = SettingViewViewModel()
    
    var body: some View {
            VStack(alignment: .leading){
                Form {
                    Section {
                        Text("Nome: ")
                        Text("Cognome: ")
                        Text("Email: ")
                        Text("Password: ")
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
        SettingsView()
    }
}
