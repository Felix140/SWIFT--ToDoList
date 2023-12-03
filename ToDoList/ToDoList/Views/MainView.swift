import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            LoginView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
