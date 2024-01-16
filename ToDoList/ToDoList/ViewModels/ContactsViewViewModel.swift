import Foundation
import FirebaseAuth
import FirebaseFirestore

class ContactsViewViewModel: ObservableObject {
    
    @Published var privateContacts = [User]()
    let db = Firestore.firestore()
    
    init() {}
    
    func searchAllContacts() {}
    
    func saveContact(_ contact: User) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users")
            .document(currentUserId)
            .collection("contacts")
            .document(contact.name)
            .setData([
                "id": contact.id,
                "name": contact.name,
                "email": contact.email,
                "joined": contact.joined
            ]) { error in
                if let error = error {
                    print("Error saving contact: \(error.localizedDescription)")
                } else {
                    print("Contact successfully saved")
                }
            }
    }
    
    func fetchPrivateContacts() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users")
            .document(currentUserId)
            .collection("contacts")
            .addSnapshotListener { [weak self] (querySnapshot, error) in /// addSnapshotListener è come getDocument, soloche si tiene sempre in ascolto(asincrona)
                if let error = error {
                    print("Error getting documents: \(error.localizedDescription)")
                } else {
                    self?.privateContacts = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: User.self)
                    } ?? []
                }
            }
    }
    
    
    func deleteContact() {}
    
    
}
