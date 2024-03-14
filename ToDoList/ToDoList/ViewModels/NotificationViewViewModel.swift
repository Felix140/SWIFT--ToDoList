import Foundation
import FirebaseAuth
import FirebaseFirestore

/// Questa classe eredita le proprietà di NewItemViewViewModel
class NotificationViewViewModel: NewItemViewViewModel {
    
    
    @Published var notifications: [TaskNotification] = []
    @Published var sendRequests: [TaskNotification] = []
    @Published var friendRequests: [FriendRequestNotification] = []
    @Published var isShowingBadge: Bool = true
    var contactViewModel = ContactsViewViewModel()
    
    override init() {
        super.init() /// Chiamata al costruttore della superclasse
    }
    
    // MARK: - TaskNotification
    
    func sendRequest(recipient: User) {
        guard canSave() else { return }
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        db.collection("users") /// DB ereditato
            .document(currentUserID)
            .getDocument { [weak self] document, error in
                if let document = document, document.exists {
                    do {
                        let currentUser = try document.data(as: User.self)
                        print("Utente mittente: \(currentUser.name)")
                        self?.createAndSendNotification(sender: currentUser, recipient: recipient)
                        print("Richiesta inviata")
                    } catch {
                        print(error)
                        print("Richiesta NON inviata")
                    }
                } else {
                    print("Documento NON esistente")
                }
            }
    }
    
    func createAndSendNotification(sender: User, recipient: User) {
        let newIdNotification = UUID().uuidString
        let newIdTask = UUID().uuidString
        let currentUserID = Auth.auth().currentUser?.uid ?? ""
        
        let newNotification = TaskNotification(
            id: newIdNotification,
            sender: User(id: currentUserID, name: sender.name, email: sender.email, joined: sender.joined),
            recipient: User(id: recipient.id, name: recipient.name, email: recipient.email, joined: recipient.joined),
            isShowed: true,
            timeCreation: Date().timeIntervalSince1970,
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
            .document(recipient.id)
            .collection("notifications")
            .document(newNotification.id)
            .setData(
                newNotification
                    .taskNotificationsAsDictionary(for: newNotification)
            )
        
        /// Salva la notifica nel database users sendNotifications
        db.collection("users")
            .document(currentUserID)
            .collection("sendNotifications")
            .document(newNotification.id)
            .setData(
                newNotification
                    .taskNotificationsAsDictionary(for: newNotification)
            )
        
        /// Salvare il Modello nel DB NOTIFICHE IN DESTINATARIO
        db.collection("notifications")
            .document(recipient.id)
            .collection("requests")
            .document(newNotification.id)
            .setData(
                newNotification
                    .taskNotificationsAsDictionary(for: newNotification)
            )
        
        print("Request Sended")
    }
    
    // MARK: - FriendNotification
    
    func sendFriendRequest(recipient: User) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        db.collection("users") /// DB ereditato
            .document(currentUserID)
            .getDocument { [weak self] document, error in
                if let document = document, document.exists {
                    do {
                        let currentUser = try document.data(as: User.self)
                        print("Utente mittente: \(currentUser.name)")
                        self?.createAndSendFriendRequest(sender: currentUser, recipient: recipient)
                        print("Richiesta inviata")
                    } catch {
                        print(error)
                        print("Richiesta NON inviata")
                    }
                } else {
                    print("Documento NON esistente")
                }
            }
    }
    
    func createAndSendFriendRequest(sender: User, recipient: User) {
        let newIdNotification = UUID().uuidString
        let currentUserID = Auth.auth().currentUser?.uid ?? ""
        
        let newFriendNotification = FriendRequestNotification(
            id: newIdNotification,
            sender: User(id: currentUserID, name: sender.name, email: sender.email, joined: sender.joined),
            recipient: User(id: recipient.id, name: recipient.name, email: recipient.email, joined: recipient.joined),
            isShowed: true,
            timeCreation: Date().timeIntervalSince1970,
            state: FriendRequestNotification.FriendRequestState.pending.rawValue,
            userContact: UserContact(
                id: recipient.id,
                name: recipient.name,
                email: recipient.email,
                joined: recipient.joined,
                isSaved: true)
        )
        
        /// Salva la notifica nel database users SENDTO
        db.collection("users")
            .document(currentUserID)
            .collection("sendTo")
            .document(recipient.id)
            .collection("notifications")
            .document(newFriendNotification.id)
            .setData(
                newFriendNotification
                    .friendNotificationsAsDictionary(for: newFriendNotification)
            )
        
        /// Salva la notifica nel database users sendNotifications
        db.collection("users")
            .document(currentUserID)
            .collection("sendNotifications")
            .document(newFriendNotification.id)
            .setData(
                newFriendNotification
                    .friendNotificationsAsDictionary(for: newFriendNotification)
            )
        
        /// Salvare il Modello nel DB NOTIFICHE IN DESTINATARIO
        db.collection("notifications")
            .document(recipient.id)
            .collection("friendRequests")
            .document(newFriendNotification.id)
            .setData(
                newFriendNotification
                    .friendNotificationsAsDictionary(for: newFriendNotification)
            )
        
        print("Friend Request Sended")
    }
    
    // MARK: - FetchTask & FetchFriendRequest
    
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
                
                var fetchedNotifications: [TaskNotification] = []
                
                for document in querySnapshot!.documents {
                    let data = document.data()
                    /// Verifica se la notifica è stata gestita
                    let isShowed = data["isShowed"] as? Bool ?? false
                    /// Solo se la notifica è visibile, la aggiungi all'elenco
                    if isShowed {
                        /// Converti il campo 'task' in ToDoListItem
                        var task: ToDoListItem?
                        if let taskData = data["task"] as? [String: Any],
                           let jsonData = try? JSONSerialization.data(withJSONObject: taskData),
                           let decodedTask = try? JSONDecoder().decode(ToDoListItem.self, from: jsonData) {
                            task = decodedTask
                        }
                        
                        /// Crea un'istanza di Notification se task esiste
                        if let task = task,
                           let senderData = data["sender"] as? [String: Any],
                           let recipientData = data["recipient"] as? [String: Any] {
                            let sender = User(
                                id: senderData["id"] as? String ?? "",
                                name: senderData["name"] as? String ?? "Unknown",
                                email: senderData["email"] as? String ?? "no-email",
                                joined: senderData["joined"] as? TimeInterval ?? 0
                            )
                            let recipient = User(
                                id: recipientData["id"] as? String ?? "",
                                name: recipientData["name"] as? String ?? "Unknown",
                                email: recipientData["email"] as? String ?? "no-email",
                                joined: recipientData["joined"] as? TimeInterval ?? 0
                            )
                            let newNotification = TaskNotification(
                                id:  data["id"] as? String ?? "",
                                sender: sender,
                                recipient: recipient,
                                isShowed: data["isShowed"] as? Bool ?? true,
                                timeCreation: data["timeCreation"] as? TimeInterval ?? Date().timeIntervalSince1970,
                                task: task,
                                isAccepted: data["isAccepted"] as? Bool ?? false
                            )
                            fetchedNotifications.append(newNotification)
                        }
                        
                    }
                }
                
                DispatchQueue.main.async {
                    self?.notifications = fetchedNotifications
                }
            }
    }
    
    func fetchFriendRequest() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("notifications")
            .document(userId)
            .collection("friendRequests")
            .addSnapshotListener { [weak self] (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                    return
                }
                
                var fetchedFriendRequests: [FriendRequestNotification] = []
                
                for document in querySnapshot!.documents {
                    let data = document.data()
                    /// Verifica se la notifica è stata gestita
                    let isShowed = data["isShowed"] as? Bool ?? false
                    /// Solo se la notifica è visibile, la aggiungi all'elenco
                    if isShowed {
                        if let senderData = data["sender"] as? [String: Any],
                           let recipientData = data["recipient"] as? [String: Any] {
                            let sender = User(
                                id: senderData["id"] as? String ?? "",
                                name: senderData["name"] as? String ?? "Unknown",
                                email: senderData["email"] as? String ?? "no-email",
                                joined: senderData["joined"] as? TimeInterval ?? 0
                            )
                            let recipient = User(
                                id: recipientData["id"] as? String ?? "",
                                name: recipientData["name"] as? String ?? "Unknown",
                                email: recipientData["email"] as? String ?? "no-email",
                                joined: recipientData["joined"] as? TimeInterval ?? 0
                            )
                            let newFriendRequest = FriendRequestNotification(
                                id: data["id"] as? String ?? "",
                                sender: sender,
                                recipient: recipient,
                                isShowed: data["isShowed"] as? Bool ?? true,
                                timeCreation: data["timeCreation"] as? TimeInterval ?? Date().timeIntervalSince1970,
                                state:  data["state"] as? FriendRequestNotification.FriendRequestState.RawValue ?? FriendRequestNotification.FriendRequestState.pending.rawValue,
                                userContact: UserContact(
                                    id: data["id"] as? String ?? "",
                                    name: recipient.name,
                                    email: recipient.email,
                                    joined: recipient.joined,
                                    isSaved: false
                                )
                            )
                            fetchedFriendRequests.append(newFriendRequest)
                        } else {
                            print("Error Fetch Friend Notification")
                        }
                    }
                }
                DispatchQueue.main.async {
                    self?.friendRequests = fetchedFriendRequests
                }
            }
    }
    
    // MARK: - TaskNotification actions
    
    func sendResponseAccepted(notification: TaskNotification) {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Errore: ID utente non disponibile.")
            return
        }
        
        let notificationId = notification.id
        let task = notification.task
        
        /// Aggiorna lo stato della notifica su Firestore
        db.collection("notifications")
            .document(userId)
            .collection("requests")
            .document(notificationId)
            .updateData(["isAccepted": true, "isShowed": false]) { error in
                if let error = error {
                    print("Errore nell'aggiornamento dello stato della notifica: \(error)")
                } else {
                    print("Notifica aggiornata con successo.")
                }
            }
        
        /// Aggiunge la task accettata alla collezione "todos" dell'utente
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
    
    func sendResponseRejected(notification: TaskNotification) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Errore: ID utente non disponibile.")
            return
        }
        let notificationId = notification.id
        /// Aggiorna lo stato della notifica su Firestore
        db.collection("notifications")
            .document(userId)
            .collection("requests")
            .document(notificationId)
            .updateData(["isAccepted": false, "isShowed": false]) { error in
                if let error = error {
                    print("Errore nell'aggiornamento dello stato della notifica: \(error)")
                } else {
                    print("Notifica aggiornata con successo.")
                }
            }
        print("Request rejected")
    }
    
    func deleteNotification(notification: TaskNotification) {
        
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
    
    func deleteSendRequest(sendNotification: TaskNotification) {
        
        guard canSave() else { return }
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users") /// DB ereditato
            .document(currentUserID)
            .collection("sendNotifications")
            .document(sendNotification.id)
            .delete()
        
        print("Eliminazione sendNotification")
    }
    
    // MARK: - FriendNotification actions
    
    func acceptFriendRequest(_ friendRequestObj: FriendRequestNotification) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        ///Modifica in Notifications
        db.collection("notifications")
            .document(userId)
            .collection("friendRequests")
            .document(friendRequestObj.id)
            .updateData([
                "isShowed": false,
                "state": FriendRequestNotification.FriendRequestState.confirmed.rawValue]) { error in
                if let error = error {
                    print("Errore nell'aggiornamento dello stato della notifica: \(error)")
                } else {
                    print("Notifica aggiornata con successo.")
                }
            }
        
        /// modifica la notifica nel database users sendNotifications
        db.collection("users")
            .document(friendRequestObj.sender.id)
            .collection("sendNotifications")
            .document(friendRequestObj.id)
            .updateData([
                "isShowed": false,
                "state": FriendRequestNotification.FriendRequestState.confirmed.rawValue]) { error in
                if let error = error {
                    print("Errore nell'aggiornamento dello stato della notifica: \(error)")
                } else {
                    print("Notifica aggiornata con successo.")
                }
            }
        
        db.collection("users")
            .document(friendRequestObj.sender.id)
            .collection("sendTo")
            .document(friendRequestObj.recipient.id)
            .collection("notifications")
            .document(friendRequestObj.id)
            .updateData([
                "isShowed": false,
                "state": FriendRequestNotification.FriendRequestState.confirmed.rawValue]) { error in
                if let error = error {
                    print("Errore nell'aggiornamento dello stato della notifica: \(error)")
                } else {
                    print("Notifica aggiornata con successo.")
                }
            }
        
        ///Save contact
//        contactViewModel.saveContact(friendRequestObj.userContact)
        print("FriendRequest accepted")
    }
    
    func rejectFriendRequest(_ friendRequestObj: FriendRequestNotification) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        ///Modifica in Notifications
        db.collection("notifications")
            .document(userId)
            .collection("friendRequests")
            .document(friendRequestObj.id)
            .updateData([
                "isShowed": false,
                "state": FriendRequestNotification.FriendRequestState.refused.rawValue]) { error in
                if let error = error {
                    print("Errore nell'aggiornamento dello stato della notifica: \(error)")
                } else {
                    print("Notifica aggiornata con successo.")
                }
            }
        
        /// modifica la notifica nel database users sendNotifications
        db.collection("users")
            .document(friendRequestObj.sender.id)
            .collection("sendNotifications")
            .document(friendRequestObj.id)
            .updateData([
                "isShowed": false,
                "state": FriendRequestNotification.FriendRequestState.refused.rawValue]) { error in
                if let error = error {
                    print("Errore nell'aggiornamento dello stato della notifica: \(error)")
                } else {
                    print("Notifica aggiornata con successo.")
                }
            }
        
        db.collection("users")
            .document(friendRequestObj.sender.id)
            .collection("sendTo")
            .document(friendRequestObj.recipient.id)
            .collection("notifications")
            .document(friendRequestObj.id)
            .updateData([
                "isShowed": false,
                "state": FriendRequestNotification.FriendRequestState.refused.rawValue]) { error in
                if let error = error {
                    print("Errore nell'aggiornamento dello stato della notifica: \(error)")
                } else {
                    print("Notifica aggiornata con successo.")
                }
            }
        
        print("FriendRequest refused")
    }
    
    
}

