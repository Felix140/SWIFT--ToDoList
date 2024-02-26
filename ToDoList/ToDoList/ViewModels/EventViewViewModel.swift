import Foundation
import FirebaseFirestore
import FirebaseAuth

class EventViewViewModel: ObservableObject {
    
    @Published var isOpenEditModal: Bool = false
    
    let db = Firestore.firestore()
    
    func deleteEvent(event: EventItem) {
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users") /// indicate COLLECTION
            .document(userId) /// passing user ID
            .collection("events")
            .document(event.id)
            .delete() /// DELETE ITEM
    }
    
    func updateEvent(event: EventItem) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let documentRef = db.collection("users").document(userId).collection("events").document(event.id)
    
        documentRef.setData([
            "id": event.id,
            "title": event.title,
            "startDate": event.startDate,
            "endDate": event.endDate,
            "createdDate": event.createdDate,
            "category": event.category.rawValue,
            "description": event.description.asDictionary() // Converto in Dizionario
        ], merge: true) { error in
            if let error = error {
                print("Errore nell'aggiornamento del task: \(error)")
            } else {
                print("Task aggiornato con successo.")
            }
        }
        
    }

}
