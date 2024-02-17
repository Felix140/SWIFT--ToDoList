import Foundation
import FirebaseFirestore

class ToDoListViewViewModel: ObservableObject {
    
    @Published var isPresentingView: Bool = false
    @Published var isPresentingSetView: Bool = false
    @Published var showingDeleteConfirmation = false
    @Published var itemToDelete: ToDoListItem?
    private var userId: String
    let db = Firestore.firestore()
    
    init(userId: String) {
        self.userId = userId
    }
    
    func onOpenEditButtons(item: ToDoListItem) {
        itemToDelete = item
        showingDeleteConfirmation = true
    }
    
    func confirmAndDelete() {
        if let item = itemToDelete {
            delete(idItem: item.id)
            itemToDelete = nil
            showingDeleteConfirmation = false
        }
    }
    
    func delete(idItem: String) {
        
        db.collection("users") /// indicate COLLECTION
            .document(userId) /// passing user ID
            .collection("todos")
            .document(idItem)
            .delete() /// DELETE ITEM
    }
    
    func deleteByGroup(idItems: [String]) {
        idItems.forEach { id in
            delete(idItem: id)
        }
    }
    
    
    func updateTask(item: ToDoListItem) {
        
        let documentRef = db.collection("users").document(userId).collection("todos").document(item.id)

        documentRef.setData([
            "id": item.id,
            "title": item.title,
            "dueDate": item.dueDate,
            "createdDate": item.createdDate,
            "isDone": item.isDone,
            "category": item.category.rawValue,
            "description": item.description.asDictionary() // Converto in Dizionario
        ], merge: true) { error in
            if let error = error {
                print("Errore nell'aggiornamento del task: \(error)")
            } else {
                print("Task aggiornato con successo.")
            }
        }
    }

}
