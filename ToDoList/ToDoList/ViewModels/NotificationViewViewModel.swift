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
    @Published var notifications: [Notification] = []
    
    override init() {
        super.init() // Chiamata al costruttore della superclasse
    }
    
    func sendRequest(sendTo userId: String) {
        
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
                                           recipient: userId,
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
            .document(newNotification.id)
            .setData(newNotification.asDictionary())
        
        /// Salvare il Modello nel DB NOTIFICHE IN DESTINATARIO
        let dbNotifications = Firestore.firestore()
        dbNotifications.collection("notifications")
            .document(newNotification.recipient)
            .collection("requests")
            .document(newIdNotification)
            .setData(newNotification.asDictionary())
        
        print("Request Sended")
        
    }
    
    func fetchNotifications() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("notifications")
            .document(userId)
            .collection("requests")
            .addSnapshotListener { [weak self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    return
                }
                
                var fetchedNotifications: [Notification] = []
                
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    // Converti il campo 'task' in ToDoListItem
                    var task: ToDoListItem?
                    if let taskData = data["task"] as? [String: Any],
                       let jsonData = try? JSONSerialization.data(withJSONObject: taskData),
                       let decodedTask = try? JSONDecoder().decode(ToDoListItem.self, from: jsonData) {
                        task = decodedTask
                    }
                    
                    // Crea un'istanza di Notification se task esiste
                    if let task = task {
                        let newNotification = Notification(
                            id: data["id"] as? String ?? "",
                            sender: data["sender"] as? String ?? "",
                            recipient: data["recipient"] as? String ?? "",
                            task: task,
                            isAccepted: data["isAccepted"] as? Bool ?? false
                        )
                        fetchedNotifications.append(newNotification)
                    }
                }
                
                DispatchQueue.main.async {
                    self?.notifications = fetchedNotifications
                }
            }
    }

    
    
    func sendResponseAccepted() { }
    
    
}

