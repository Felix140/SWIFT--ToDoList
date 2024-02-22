import SwiftUI

struct TabBarView: View {
    
    @State var userId: String
    
    var body: some View {
        TabView { /// TAB NAV
            ToDoListView(userId: userId)
                .tabItem {
                    Label("Task", systemImage: "list.bullet.circle.fill")
                }
            
            SharedToDoListView(userId: userId)
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
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    TabBarView(userId: "123456789")
}
