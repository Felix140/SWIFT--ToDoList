import Foundation
import FirebaseFirestore
import FirebaseAuth

class EventViewViewModel: ObservableObject {
    
    @Published var isOpenEditModal: Bool = false
    @Published var itemToEdit: EventItem?
    @Published var showingEditButtons = false
    let db = Firestore.firestore()
    
    
    func deleteEvent(event: EventItem) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("deleteEvent userId ERROR")
            return
        }
        db.collection("users") /// indicate COLLECTION
            .document(userId) /// passing user ID
            .collection("events")
            .document(event.id)
            .delete() /// DELETE ITEM
    }
    
    func deleteEventItem() {
        if let eventItem = itemToEdit {
            deleteEvent(event: eventItem)
            itemToEdit = nil
            showingEditButtons = false
            print("deleteEventItem Succeded")
        }
    }
    
    func updateEvent(event: EventItem) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("updateEvent userId ERROR")
            return
        }
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
    
    
    func isSameDay(date1: TimeInterval, date2: TimeInterval) -> Bool { ///    Check start e end sono uguali
        let calendar = Calendar.current
        let date1 = Date(timeIntervalSince1970: date1)
        let date2 = Date(timeIntervalSince1970: date2)
        let day1 = calendar.component(.day, from: date1)
        let month1 = calendar.component(.month, from: date1)
        let year1 = calendar.component(.year, from: date1)
        let day2 = calendar.component(.day, from: date2)
        let month2 = calendar.component(.month, from: date2)
        let year2 = calendar.component(.year, from: date2)
        return day1 == day2 && month1 == month2 && year1 == year2
    }
    
    
    func onOpenEditButtons(item: EventItem) {
        itemToEdit = item
        showingEditButtons = true
        print("Edit Buttons Opened")
    }
    
}
