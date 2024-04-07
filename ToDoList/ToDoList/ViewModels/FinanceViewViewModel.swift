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
    
    
    @Published var amountInput: Double = 0
    @Published var descriptionText = ""
    @Published var creationDate = Date()
    @Published var dateTask = Date()
    @Published var spendingType: SpendingTypology = .add
    @Published var selectedCategory: CategorySpending = .none
    let db = Firestore.firestore()
    
    
    
    func addSpending() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        let documentReference = db.collection("users").document(currentUserID).collection("finance").document("totals")

        // Assume 'totals' document contains 'totalRevenue' and 'totalSpent' fields
        documentReference.updateData([
            "totalRevenue": FieldValue.increment(Double(amountInput))
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func subtractSpending() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        let documentReference = db.collection("users").document(currentUserID).collection("finance").document("totals")

        // Assume 'totals' document contains 'totalRevenue' and 'totalSpent' fields
        documentReference.updateData([
            "totalSpent": FieldValue.increment(Double(amountInput))
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
}
