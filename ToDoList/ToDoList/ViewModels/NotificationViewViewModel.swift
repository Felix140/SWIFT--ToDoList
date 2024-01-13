import Foundation
import FirebaseAuth
import FirebaseFirestore

class NotificationViewViewModel: ObservableObject {
    
    @Published var messageTitle = ""
    @Published var category = ""
    @Published var date = Date()
    @Published var showAlert = false
    @Published var description = ""
    @Published var selectedCategory: CategoryTask = .none
    let categories = CategoryTask.allCases
    
    init() {}
    
    func sendRequest(request: Notification, sendTo: String) {
        var copyItem = request /// trasformo in variabile VAR perchè item è una costante
        copyItem.setAccepted(!request.isAccepted)
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        /// Creazione Notifica + Modello da mandare
        let newId = UUID().uuidString
        let newNotification = Notification(id: newId,
                                           sender: userId,
                                           recipient: sendTo,
                                           task: ToDoListItem(id: newId,
                                                              title: messageTitle,
                                                              dueDate: date.timeIntervalSince1970,
                                                              createdDate: Date().timeIntervalSince1970,
                                                              isDone: false,
                                                              category: selectedCategory,
                                                              description: InfoToDoItem(id: newId,
                                                                                        description: description)),
                                           isAccepted: false)
        
        /// Salvare il Modello nel DB
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("sendTo")
            .document(sendTo)
            .setData(newNotification.asDictionary())
        
        print("Request Sended")
        
    }
    
    func sendResponseAccepted() { }
    
    
    /// Check dei campi prima del salvataggio
    func canSave() -> Bool {
        guard !messageTitle.trimmingCharacters(in: .whitespaces).isEmpty else {
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
