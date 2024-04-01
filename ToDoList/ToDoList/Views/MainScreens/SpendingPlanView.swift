import SwiftUI

struct SpendingPlanView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Spending Planner")
                }
                .navigationTitle("Spending Plan")
                .toolbar {
                    ToolbarItem(content: {
                        
                    })
                }
            }
        }
    }
}

//#Preview {
//    SharedToDoListView(userId: "dK6CG6dD7vUwHggvLO2jjTauQGA3")
//}

struct SpendingPlannerView_Preview: PreviewProvider {
    static var previews: some View {
        SpendingPlanView()
    }
}
