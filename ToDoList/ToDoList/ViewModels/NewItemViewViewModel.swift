import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewItemViewViewModel: ObservableObject {
    
    @Published var title = ""
    @Published var category = ""
    @Published var date = Date()
    @Published var showAlert = false
    @Published var isOnPomodoro = false
    
    init() {}
    
    func save() {
        /// Check canSave() function
        guard  canSave() else {
            return
        }
        
        /// Get userID corrente
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        /// Creazione Modello da mandare
        let newId = UUID().uuidString
        let newItem = ToDoListItem(id: newId,
                                   title: title,
                                   dueDate: date.timeIntervalSince1970,
                                   createdDate: Date().timeIntervalSince1970, // La data senza la proprietà @Published
                                   isDone: false,
                                   pomodoro: isOnPomodoro, 
                                   category: category)
        
        /// Salvare il Modello nel DB
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("ToDos")
            .document(newId)
            .setData(newItem.asDictionary())
        
        print("New Item Saved")
    }
    
    
    
    /// Check dei campi prima del salvataggio
    func canSave() -> Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("Riempi il titolo")
            return false
        }
        ///Check su  DATE >= di IERI ( giorno corrente: Date(), sottratto da -86400: ovver secondi in un giorno )
        guard date >= Date().addingTimeInterval(-86400) else {
            print("Giorno non Valido")
            return false
        }
        return true
    }
    
    
}
