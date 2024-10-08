import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewItemViewViewModel: ObservableObject {
    
    @Published var title = ""
    @Published var date = Date()
    @Published var date2 = Date()
    @Published var showAlert = false
    @Published var description = ""
    @Published var selectedCategory: CategoryTask = .none
    let categories = CategoryTask.allCases
    let db = Firestore.firestore()
    
    init() {}
    
    func save() {
        /// Check canSave() function
        guard  canSave() else { return }
        /// Get userID corrente
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        /// Creazione Modello da mandare
        let newId = UUID().uuidString
        let newItem = ToDoListItem(id: newId,
                                   title: title,
                                   dueDate: date.timeIntervalSince1970,
                                   createdDate: Date().timeIntervalSince1970,
                                   isDone: false,
                                   category: selectedCategory,
                                   description: InfoToDoItem(id: newId,
                                                             description: description))
        
        /// Salvare il Modello nel DB
        db.collection("users")
            .document(userId)
            .collection("todos")
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
        ///Check su  DATE2 > di DATE1 ( giorno corrente: Date(), sottratto da -86400: ovver secondi in un giorno )
        guard date2 >= date else {
            print("Secondo giorno è minore del primo giorno")
            return false
        }
        return true
    }
    
    func canAddDescription() -> Bool {
        guard !description.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("Riempi la descrizione")
            return false
        }
        
        return true
    }
    
    func saveEvent() {
        guard  canSave() else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let newId = UUID().uuidString
        
        let newEventItem = EventItem(id: newId,
                                title: title,
                                startDate: date.timeIntervalSince1970,
                                endDate: date2.timeIntervalSince1970,
                                createdDate: Date().timeIntervalSince1970,
                                category: selectedCategory,
                                description: InfoToDoItem(id: newId, description: description))
        
        db.collection("users")
            .document(userId)
            .collection("events")
            .document(newId)
            .setData(newEventItem.asDictionary())
        
        print("New Event Saved")
    }
}
