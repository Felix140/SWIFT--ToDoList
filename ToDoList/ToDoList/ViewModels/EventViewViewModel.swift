import Foundation
import FirebaseFirestore
import FirebaseAuth

class EventViewViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    func deleteEvent(event: EventItem) {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        db.collection("users") /// indicate COLLECTION
            .document(userId) /// passing user ID
            .collection("events")
            .document(event.id)
            .delete() /// DELETE ITEM
    }

}
