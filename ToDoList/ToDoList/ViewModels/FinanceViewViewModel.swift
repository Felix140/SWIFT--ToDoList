import Foundation
import FirebaseAuth
import FirebaseFirestore


class FinanceViewViewModel: ObservableObject {
    @Published var isPresentingView: Bool = false
    @Published var totalRevenue: Double = 100.0
    @Published var totalSpent: Double = 50.0
    
    var difference: Double {
        totalRevenue - totalSpent
    }
    
    
    func addSpending() {}
    func subtractSpending() {}
    
}
