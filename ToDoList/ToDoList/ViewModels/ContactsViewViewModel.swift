import Foundation
import FirebaseAuth
import FirebaseFirestore

class ContactsViewViewModel: ObservableObject {
    
    @Published var privateContacts = [UserContact]()
    let db = Firestore.firestore()
    
    init() {}
    
    func searchAllContacts() {}
    
    func saveContact(_ contact: UserContact) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users")
            .document(currentUserId)
            .collection("contacts")
            .document(contact.id)
            .setData([
                "id": contact.id,
                "name": contact.name,
                "email": contact.email,
                "joined": contact.joined,
                "isSaved": contact.isSaved
            ]) { error in
                if let error = error {
                    print("Error saving contact: \(error.localizedDescription)")
                } else {
                    print("Contact successfully saved")
                }
            }
    }
    
    func fetchPrivateContacts() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Errore: ID utente non disponibile.")
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
    }
    
    func checkIsSaved(userContactId: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Errore: ID utente non disponibile.")
            return
        }

        // Riferimento al documento specifico nella collezione 'contacts'
        let contactRef = db.collection("users")
                           .document(currentUserId)
                           .collection("contacts")
                           .document(userContactId)

        contactRef.getDocument { [weak self] (documentSnapshot, error) in
            if let error = error {
                print("Errore nel recuperare il contatto: \(error.localizedDescription)")
            } else {
                // Cerca l'utente in privateContacts e aggiorna isSaved
                if let index = self?.privateContacts.firstIndex(where: { $0.id == userContactId }) {
                    self?.privateContacts[index].isSaved = documentSnapshot?.exists ?? false
                }
            }
        }
    }

    
    
}
