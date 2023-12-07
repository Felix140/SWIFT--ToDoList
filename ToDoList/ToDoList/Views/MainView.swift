import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()
    
    var body: some View {
        
        if viewModel.isSignedIn,
           !viewModel.currentUserId.isEmpty {
            
           navbar
            
        } else {
            LoginView()
        }
        
    }
    
    @ViewBuilder
    var navbar: some View {
        TabView { /// Navbar
            ToDoListView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
