import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel = MainViewViewModel()
    var body: some View {
        
        if viewModel.isSignedIn,
           !viewModel.currentUserId.isEmpty {
            
            TabBarView(userId: viewModel.currentUserId)
            
        } else {
            StartView()
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
