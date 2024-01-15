import Foundation
import FirebaseAuth
import FirebaseFirestore

class ContactsViewViewModel: ObservableObject {
    
    @Published var privateContacts = [User]()
    
    init() {}
    
    func searchAllContacts() {}
    
    func saveContact(_ contact: User) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
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
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(currentUserId)
            .collection("contacts")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error.localizedDescription)")
                } else {
                    self.privateContacts = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: User.self)
                    } ?? []
                }
            }
    }
    
    
    func deleteContact() {}
    
    
}
