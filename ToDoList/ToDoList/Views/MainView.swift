import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel = MainViewViewModel()
    
    var body: some View {
        
        if viewModel.isSignedIn,
           !viewModel.currentUserId.isEmpty {
            
           navbar
            
        } else {
            StartView()
        }
        
    }
    
    @ViewBuilder
    var navbar: some View {
        TabView { /// TAB NAV
            ToDoListView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("Task", systemImage: "list.bullet.circle.fill")
                }
            
            
            SharedToDoListView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("Shared", systemImage: "rectangle.stack.badge.person.crop")
                }
            
            ContactsView()
                .tabItem {
                    Label("Contacts", systemImage: "person.2.circle")
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
