import SwiftUI


struct SettingsView: View {
    
    @StateObject var viewModel = SettingViewViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                Text("Nome")
                Text("Cognome")
                Text("Email")
                Text("Password")
                Spacer()
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Preview: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
