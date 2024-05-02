import Foundation
import Firebase
import FirebaseFirestore

class HistoryFinanceViewViewModel: FinanceViewViewModel {
    
    func fetchHistoryItems(bySpendingType spendingType: SpendingTypology, completion: @escaping ([HistoryFinanceItem]) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }
        
        let historyReference = db.collection("users")
            .document(currentUserID)
            .collection("finance")
            .document(currentYear)
            .collection("history")
        
        let query: Query
        if spendingType == .all {
            query = historyReference
        } else {
            query = historyReference.whereField("spendingType", isEqualTo: spendingType.rawValue)
        }
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching history items: \(error)")
                completion([])
                return
            }
            
            let items = querySnapshot?.documents.compactMap { document -> HistoryFinanceItem? in
                try? document.data(as: HistoryFinanceItem.self)
            } ?? []
            completion(items)
        }
    }

}
