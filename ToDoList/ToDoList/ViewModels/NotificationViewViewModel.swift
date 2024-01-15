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
        guard canSave() else {
            return
        }
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(currentUserID).getDocument { [weak self] document, error in
            if let document = document, document.exists {
                let currentUser = try? document.data(as: User.self)
                // Qui estraggo il nome dell'utente corrente
                let currentUserName = currentUser?.name ?? "Unknown"
                print("Utente mittente: \(currentUserName)")
                self?.createAndSendNotification(senderName: currentUserName, sendTo: userId)
                print("Richiesta inviata")
            } else {
                print("Document does not exist")
            }
        }
    }

    
    
    func createAndSendNotification(senderName: String, sendTo userId: String) {
        let newIdNotification = UUID().uuidString
        let newIdTask = UUID().uuidString
        let currentUserID = Auth.auth().currentUser?.uid ?? ""
        
        let newNotification = Notification(
            id: newIdNotification,
            sender: currentUserID,
            senderName: senderName, // Assegna il nome recuperato
            recipient: userId,
            task: ToDoListItem(
                id: newIdTask,
                title: title,
                dueDate: date.timeIntervalSince1970,
                createdDate: Date().timeIntervalSince1970,
                isDone: false,
                category: selectedCategory,
                description: InfoToDoItem(
                    id: newIdTask,
                    description: description
                )
            ),
            isAccepted: false
        )
        
        // Salva la notifica nel database...
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
                            senderName: data["senderName"] as? String ?? "Unknown", // Assicurati che questo campo sia assegnato correttamente
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

