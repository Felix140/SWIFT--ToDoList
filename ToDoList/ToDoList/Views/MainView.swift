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
        TabView { /// Navbar
            ToDoListView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("Task", systemImage: "list.bullet.circle.fill")
                }
            
            DoneListView()
                .tabItem {
                    Label("Done", systemImage: "checklist.checked")
                }
            
            PomodoroTimerView()
                .tabItem {
                    Label("Pomodoro", systemImage: "microbe")
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
