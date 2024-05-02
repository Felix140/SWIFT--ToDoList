import Foundation
import FirebaseAuth
import FirebaseFirestore


class FinanceViewViewModel: ObservableObject {
    
    @Published var isPresentingView: Bool = false
    @Published var totalRevenue: Double = 0
    @Published var totalSpent: Double = 0 /// Assicurato essere sempre positivo attraverso la logica di aggiunta
    @Published var totalAmount: Double = 0
    
    @Published var amountInput: Double = 0
    @Published var descriptionText = ""
    @Published var creationDate = Date()
    @Published var dateTask = Date()
    @Published var spendingType: SpendingTypology = .add
    @Published var selectedCategory: CategorySpending = .none
    
    let db = Firestore.firestore()
    var currentYear: String {
        creationDate.formatted(.dateTime.year())
    }
    
    init() {
        fetchFinanceData()
    }
    
    private func fetchFinanceData() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let financeReference = db.collection("users").document(currentUserID).collection("finance").document(currentYear)
        
        financeReference.getDocument { [weak self] (document, error) in
            if let document = document, document.exists, let data = document.data() {
                DispatchQueue.main.async {
                    /// Assegna i valori recuperati da Firebase alle proprietà dell'oggetto
                    self?.totalRevenue = data["totalRevenue"] as? Double ?? 0
                    self?.totalSpent = data["totalSpent"] as? Double ?? 0
                    self?.totalAmount = data["totalAmount"] as? Double ?? 0
                }
            } else {
                print("Document does not exist or error: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    
    func initializeTotalAmount() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let financeReference = db.collection("users").document(currentUserID).collection("finance").document(currentYear)
        
        financeReference.setData([
            "totalAmount": 0,  /// Setting totalAmount to 0
        ], merge: true) { error in
            if let error = error {
                print("Error setting document: \(error)")
            } else {
                print("Document successfully set with initial totalAmount")
            }
        }
    }
    
    
    private func updateTotalAmount(completion: @escaping (Bool) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        let documentReference = db.collection("users").document(currentUserID).collection("finance").document(currentYear)
        documentReference.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(true)
            } else {
                documentReference.setData(["totalAmount": 0], merge: true) { error in
                    if let error = error {
                        print("Error setting initial totalAmount: \(error)")
                        completion(false)
                    } else {
                        print("totalAmount initialized to 0")
                        completion(true)
                    }
                }
            }
        }
    }
    
    func addSpending(value: Double) {
        updateTotalAmount { [weak self] exists in
            guard exists, let self = self else { return }
            guard let currentUserID = Auth.auth().currentUser?.uid else { return }
            let documentReference = self.db.collection("users").document(currentUserID).collection("finance").document(currentYear)
            let incrementAmount = FieldValue.increment(value)
            
            let updateFields: [String: Any] = self.spendingType == .add ? ["totalRevenue": incrementAmount, "totalAmount": FieldValue.increment(value)] : [:]
            
            documentReference.updateData(updateFields) { [weak self] error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document successfully updated: Increment")
                    self?.fetchFinanceData() // Aggiorna i valori dopo l'aggiornamento del db
                }
            }
            
            
            let newId = UUID().uuidString
            let newItem = HistoryFinanceItem(
                id: newId,
                amount: value,
                descriptionText: descriptionText,
                spendingType: spendingType,
                creationDate: creationDate.timeIntervalSince1970,
                dateTask: creationDate.timeIntervalSince1970,
                category: selectedCategory,
                status: .confirmed)
            
            documentReference
                .collection("history")
                .document(newItem.id)
                .setData(newItem.asDictionary())
            
            print("New Spending Item CREATED: increment")
        }
    }
    
    func subtractSpending(value: Double) {
        updateTotalAmount { [weak self] exists in
            guard exists, let self = self else { return }
            guard let currentUserID = Auth.auth().currentUser?.uid else { return }
            let documentReference = self.db.collection("users").document(currentUserID).collection("finance").document(currentYear)
            
            let positiveValue = abs(value) /// Assicura che il valore sia positivo.
            
            /// Aggiorna solo totalSpent, poiché totalRevenue non dovrebbe mai diventare negativo qui.
            let incrementSpent = FieldValue.increment(positiveValue)
            
            /// Prepariamo l'aggiornamento per totalSpent.
            let updateFields: [String: Any] = ["totalSpent": incrementSpent, "totalAmount": FieldValue.increment(-positiveValue)]
            
            /// Qui potresti voler aggiungere una logica per controllare e aggiustare totalRevenue se necessario, basato sulla tua logica di app.
            
            documentReference.updateData(updateFields) { [weak self] error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document successfully updated: Spent added")
                    self?.fetchFinanceData() /// Aggiorna i valori dopo l'aggiornamento del database.
                }
            }
            
            let newId = UUID().uuidString
            let newItem = HistoryFinanceItem(
                id: newId,
                amount: value,
                descriptionText: descriptionText,
                spendingType: spendingType,
                creationDate: creationDate.timeIntervalSince1970,
                dateTask: creationDate.timeIntervalSince1970,
                category: selectedCategory,
                status: .confirmed)
            
            documentReference
                .collection("history")
                .document(newItem.id)
                .setData(newItem.asDictionary())
            
            print("New Spending Item CREATED: decrement")
        }
    }
    
    
    
}
