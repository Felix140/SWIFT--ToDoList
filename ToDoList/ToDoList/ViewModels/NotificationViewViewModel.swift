import Foundation
import FirebaseAuth
import FirebaseFirestore

class NotificationViewViewModel: ObservableObject {
    
    @Published var title = ""
    @Published var category = ""
    @Published var date = Date()
    @Published var showAlert = false
    @Published var description = ""
    @Published var selectedCategory: CategoryTask = .none
    let categories = CategoryTask.allCases
    
    init() {}
    
    func sendRequest(request: Notification) {
        var copyItem = request /// trasformo in variabile VAR perchè item è una costante
        copyItem.setAccepted(!request.isAccepted)
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        //Update DB
        let db = Firestore.firestore()
        db.collection("notifications")
            .document(userId)
            .collection("sendTo")
            .document(copyItem.recipient.name)
            .setData(copyItem.asDictionary()) 
    }
    
    func sendResponseAccepted() { }
    
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
                                   category: selectedCategory,
                                   description: InfoToDoItem(id: newId,
                                                             description: description))
        
        /// Salvare il Modello nel DB
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("ToDos")
            .document(newId)
            .setData(newItem.asDictionary())
        
        print("Request Sended")
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
    
    func canAddDescription() -> Bool {
        guard !description.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("Riempi la descrizione")
            return false
        }
        
        return true
    }
    
}
