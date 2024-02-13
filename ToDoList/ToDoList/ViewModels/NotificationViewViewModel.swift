import Foundation
import FirebaseAuth
import FirebaseFirestore

/// Questa classe eredita le proprietà di NewItemViewViewModel
class NotificationViewViewModel: NewItemViewViewModel {
    
    
    @Published var notifications: [Notification] = []
    @Published var sendRequests: [Notification] = []
    
    override init() {
        super.init() /// Chiamata al costruttore della superclasse
    }
    
    func sendRequest(sendTo userId: String) {
        
        guard canSave() else { return }
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users") /// DB ereditato
            .document(currentUserID)
            .getDocument { [weak self] document, error in
                if let document = document, document.exists {
                    do {
                        let currentUser = try document.data(as: User.self)
                        // Qui estraggo il nome dell'utente corrente
                        let currentUserName = currentUser.name
                        print("Utente mittente: \(currentUserName)")
                        self?.createAndSendNotification(senderName: currentUserName, sendTo: userId)
                        print("Richiesta inviata")
                    } catch {
                        print(error)
                    }
                } else {
                    print("Documento NON esistente")
                }
            }
    }
    
    
    func createAndSendNotification(senderName: String, sendTo: String) {
        
        let newIdNotification = UUID().uuidString
        let newIdTask = UUID().uuidString
        let currentUserID = Auth.auth().currentUser?.uid ?? ""
        
        let newNotification = Notification(
            id: newIdNotification,
            sender: currentUserID,
            senderName: senderName, /// Assegna il nome recuperato
            recipient: sendTo,
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
        
        /// Salva la notifica nel database users SENDTO
        db.collection("users")
            .document(currentUserID)
            .collection("sendTo")
            .document(newNotification.recipient)
            .collection("notifications")
            .document(newNotification.id)
            .setData(newNotification.asDictionary())
        
        /// Salva la notifica nel database users sendNotifications
        db.collection("users")
            .document(currentUserID)
            .collection("sendNotifications")
            .document(newNotification.id)
            .setData(newNotification.asDictionary())
        
        /// Salvare il Modello nel DB NOTIFICHE IN DESTINATARIO
        db.collection("notifications")
            .document(newNotification.recipient)
            .collection("requests")
            .document(newIdNotification)
            .setData(newNotification.asDictionary())
        
        print("Request Sended")
    }
    
    
    func fetchNotifications() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
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
                    
                    /// Converti il campo 'task' in ToDoListItem
                    var task: ToDoListItem?
                    if let taskData = data["task"] as? [String: Any],
                       let jsonData = try? JSONSerialization.data(withJSONObject: taskData),
                       let decodedTask = try? JSONDecoder().decode(ToDoListItem.self, from: jsonData) {
                        task = decodedTask
                    }
                    
                    /// Crea un'istanza di Notification se task esiste
                    if let task = task {
                        let newNotification = Notification(
                            id: data["id"] as? String ?? "",
                            sender: data["sender"] as? String ?? "",
                            senderName: data["senderName"] as? String ?? "Unknown",
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
    
    func sendResponseAccepted(notification: Notification) {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Errore: ID utente non disponibile.")
            return
        }
        
        let notificationId = notification.id
        let task = notification.task
        
        // Aggiorna lo stato della notifica su Firestore
        db.collection("notifications")
            .document(userId)
            .collection("requests")
            .document(notificationId)
            .updateData(["isAccepted": true]) { error in
                if let error = error {
                    print("Errore nell'aggiornamento dello stato della notifica: \(error)")
                } else {
                    print("Notifica aggiornata con successo.")
                }
            }
        
        // Aggiunge la task accettata alla collezione "todos" dell'utente
        db.collection("users")
            .document(userId)
            .collection("todos")
            .document(task.id)
            .setData(task.asDictionary()) { error in
                if let error = error {
                    print("Errore nel salvare la task: \(error)")
                } else {
                    print("Task salvata con successo.")
                }
            }
        
        print("Request accepted")
    }
    
    func sendResponseRejected() {
        print("Rejected")
    }
    
    
    func deleteNotification(notification: Notification) {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Eliminazione notifica: utente non autorizzato")
            return
        }
        
        db.collection("notifications")
            .document(userId)
            .collection("requests")
            .document(notification.id)
            .delete()
        
    }
    
    
}

