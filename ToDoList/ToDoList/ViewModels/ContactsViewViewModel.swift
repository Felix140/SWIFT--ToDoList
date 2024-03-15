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
    
    func updateContactAsSaved(_ contact: UserContact) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        db.collection("users")
            .document(currentUserId)
            .collection("contacts")
            .document(contact.id)
            .updateData(["isSaved": true]) { error in
                if let error = error {
                    print("Errore nell'aggiornamento dello stato della notifica: \(error)")
                } else {
                    print("Notifica aggiornata con successo.")
                }
            }

    }
    
    func fetchPrivateContacts() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Errore fetchPrivateContacts: ID utente non disponibile.")
            return
        }
        db.collection("users")
            .document(currentUserId)
            .collection("contacts")
            .addSnapshotListener { [weak self] (querySnapshot, error) in /// addSnapshotListener è come getDocument, soloche si tiene sempre in ascolto(asincrona)
                if let error = error {
                    print("Error getting documents: \(error.localizedDescription)")
                } else {
                    self?.privateContacts = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: UserContact.self)
                    } as! [UserContact]
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
    
    
    func checkIsSaved(userContactId: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Errore: ID utente non disponibile.")
            return
        }
        /// Riferimento al documento specifico nella collezione 'contacts'
        let contactRef = db.collection("users")
            .document(currentUserId)
            .collection("contacts")
            .document(userContactId)
        
        contactRef.getDocument { [weak self] (documentSnapshot, error) in
            if let error = error {
                print("Errore nel recuperare il contatto: \(error.localizedDescription)")
            } else {
                /// Cerca l'utente in privateContacts e aggiorna isSaved
                if let index = self?.privateContacts.firstIndex(where: { $0.id == userContactId }) {
                    self?.privateContacts[index].isSaved = documentSnapshot?.exists ?? false
                }
            }
        }
    }
}
