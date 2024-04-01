import SwiftUI

struct TabBarView: View {
    
    @State var userId: String
    @StateObject var viewModelNotification = NotificationViewViewModel()
    
    var body: some View {
        TabView { /// TAB NAV
            ToDoListView(userId: userId)
                .tabItem {
                    Label("Task", systemImage: "list.bullet.circle.fill")
                }
            
            SpendingPlanView()
                .tabItem {
                    Label("Spending Plan", systemImage: "dollarsign.arrow.circlepath")
                }
            
            SharedToDoListView(userId: userId, viewModelNotification: viewModelNotification)
                .onAppearBadge(viewModelNotification.notifications.count , condition: viewModelNotification.isShowingBadge)
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
            // Style TABBAR
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

/// Estensione di View che aggiunge condizionalmente un badge se isShowingBadge è true
extension View {
    @ViewBuilder func onAppearBadge(_ count: Int, condition: Bool) -> some View {
        if condition && count != nil || count != 0 {
            self.badge(count)
        } else {
            self
        }
    }
}

#Preview {
    TabBarView(userId: "123456789")
}
