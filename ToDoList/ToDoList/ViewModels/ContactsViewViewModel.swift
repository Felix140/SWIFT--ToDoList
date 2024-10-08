import Foundation
import FirebaseAuth
import FirebaseFirestore

class ContactsViewViewModel: ObservableObject {
    
    @Published var privateContacts = [UserContact]()
    @Published var allUsers = [UserContact]()
    @Published var isShowingInfoUser: Bool = false
    @Published var userSelected: User?
    let db = Firestore.firestore()
    
    
    init() {
        fetchGlobalUsers()
    }
    
    
    func convertUserToUserContact(users: [User]) -> [UserContact] {
        return users.map { user in
            UserContact(id: user.id, name: user.name, email: user.email, joined: user.joined, isSaved: false)
        }
    }
    
    
    func fetchGlobalUsers() {
        ///    Si utilizza db.collection("users").getDocuments per caricare tutti i documenti dalla collezione "users".
        db.collection("users").getDocuments { [weak self] (querySnapshot, error) in
            ///    Si gestisce l'eventuale errore che potrebbe verificarsi durante il recupero dei documenti.
            if let error = error {
                print("Error getting users: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No users found")
                return
            }
            ///    Si usa compactMap per convertire ogni documento Firestore in un oggetto User. Questo richiede che la tua classe User sia conforme a Codable e che i nomi delle proprietà corrispondano ai nomi dei campi nel tuo database Firestore.
            let users = documents.compactMap { document -> User? in
                try? document.data(as: User.self)
            }
            ///    Si chiama la funzione convertUserToUserContact per convertire gli oggetti User in UserContact, impostando isSaved su false e assegna il risultato all'array allUsers nel ViewModel.
            self?.allUsers = self?.convertUserToUserContact(users: users) ?? []
        }
    }
    
    func setPendingContact(_ contact: UserContact) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        db.collection("users")
            .document(currentUserId)
            .collection("contacts")
            .document(contact.id)
            .setData(contact.userContactAsDictionary(for: contact))
        print("Set contact to pending")
        print("\(contact.userContactAsDictionary(for: contact))")
    }
    
    func updateContactAsSaved(_ friendRequestObj: FriendRequestNotification) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("notifications")
            .document(currentUserId)
            .collection("friendRequests")
            .document(friendRequestObj.id)
            .updateData(["userContact.isSaved": true]) { error in
                if let error = error {
                    print("notifications.friendRequests ERROR: \(error)")
                } else {
                    print("notifications.friendRequests: Notifica aggiornata con successo.")
                }
            }
        
        db.collection("users")
            .document(friendRequestObj.sender.id)
            .collection("contacts")
            .document(friendRequestObj.recipient.id)
            .updateData(["isSaved": true]) { error in
                if let error = error {
                    print("users.friendRequests ERROR: \(error)")
                } else {
                    print("users.friendRequests: Notifica aggiornata con successo.")
                }
            }
        
        db.collection("users")
            .document(friendRequestObj.sender.id)
            .collection("sendNotifications")
            .document(friendRequestObj.id)
            .updateData(["userContact.isSaved": true]) { error in
                if let error = error {
                    print("users.friendRequests ERROR: \(error)")
                } else {
                    print("users.friendRequests: Notifica aggiornata con successo.")
                }
            }
        
        db.collection("users")
            .document(friendRequestObj.sender.id)
            .collection("sendTo")
            .document(friendRequestObj.recipient.id)
            .collection("notifications")
            .document(friendRequestObj.id)
            .updateData(["userContact.isSaved": true]) { error in
                if let error = error {
                    print("users.sendTo.notifications ERROR: \(error)")
                } else {
                    print("users.sendTo.notifications: Notifica aggiornata con successo.")
                }
            }
    }
    
    func saveContactAfterAccept(senderContact: User, recipient: User) {
        let contactToSave = UserContact(
            id: senderContact.id,
            name: senderContact.name,
            email: senderContact.email,
            joined: senderContact.joined,
            isSaved: true)
        db.collection("users")
            .document(recipient.id)
            .collection("contacts")
            .document(contactToSave.id)
            .setData(contactToSave.userContactAsDictionary(for: contactToSave)) { error in
                if let error = error {
                    print("users.contacts senderContact ERROR: \(error)")
                } else {
                    print("users.contacts senderContact: Contatto aggiunto con successo.")
                }
            }
    }
    
    func fetchPrivateContacts() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Errore fetchPrivateContacts: ID utente non disponibile.")
            return
        }
        
        /// Utilizza `whereField:isEqualTo:` per filtrare i contatti con `isSaved` impostato su `true`
        db.collection("users")
            .document(currentUserId)
            .collection("contacts")
            .whereField("isSaved", isEqualTo: true)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error.localizedDescription)")
                } else {
                    self?.privateContacts = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: UserContact.self)
                    } ?? []
                }
            }
    }
    
    
    func deleteContact(userContactId: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Errore: ID utente non disponibile.")
            return
        }
        db.collection("users")
            .document(currentUserId)
            .collection("contacts")
            .document(userContactId)
            .delete()
        if let index = allUsers.firstIndex(where: { $0.id == userContactId }) {
            allUsers[index].isSaved = false
            print("Utente isSaved: false")
        }
    }
}
