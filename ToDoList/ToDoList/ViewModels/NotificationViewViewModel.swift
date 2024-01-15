import Foundation
import FirebaseAuth
import FirebaseFirestore

/// Questa classe eredita le proprietà di NewItemViewViewModel
class NotificationViewViewModel: NewItemViewViewModel {
    
///    @Published var messageTitle = ""
///    @Published var category = ""
///    @Published var date = Date()
///    @Published var showAlert = false
///    @Published var description = ""
///    @Published var selectedCategory: CategoryTask = .none
///    let categories = CategoryTask.allCases
    
    override init() {}
    
    func sendRequest(sendTo: String) {
        
        guard  canSave() else {
            return
        }
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        /// Creazione Notifica + Modello da mandare
        let newIdNotification = UUID().uuidString
        let newIdTask = UUID().uuidString
        
        let newNotification = Notification(id: newIdNotification,
                                           sender: userId,
                                           recipient: sendTo,
                                           task: ToDoListItem(id: newIdTask,
                                                              title: title,
                                                              dueDate: date.timeIntervalSince1970,
                                                              createdDate: Date().timeIntervalSince1970,
                                                              isDone: false,
                                                              category: selectedCategory,
                                                              description: InfoToDoItem(id: newIdTask,
                                                                                        description: description)),
                                           isAccepted: false)
        
        /// Salvare il Modello nel DB  NOTIFICHE IN UTENTE
        let dbUserSender = Firestore.firestore()
        dbUserSender.collection("users")
            .document(userId)
            .collection("sendTo")
            .document(newNotification.recipient)
            .collection("notifications")
            .document(newIdNotification)
            .setData(newNotification.asDictionary())
        
        /// Salvare il Modello nel DB NOTIFICHE IN DESTINATARIO
        let dbNotifications = Firestore.firestore()
        dbNotifications.collection("notifications")
            .document(newNotification.recipient)
            .collection("requests")
            .document(newIdNotification)
            .collection("sender")
            .document(newNotification.sender)
            .setData(newNotification.asDictionary())
        
        print("Request Sended")
        
    }
    
    func sendResponseAccepted() { }
    
    
}
