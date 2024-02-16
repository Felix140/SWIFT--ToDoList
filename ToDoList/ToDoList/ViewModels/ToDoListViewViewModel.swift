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
    
    func onEditTask(item: ToDoListItem) {
        
        // Creazione del dizionario da mandare
        let setItem: [String: Any] = [
            "id": item.id,
            "title": item.title,
            "dueDate": item.dueDate,
            "createdDate": item.createdDate,
            "isDone": item.isDone,
            "category": item.category,
            "description": item.description 
        ]
        
        /// Salvare il Modello nel DB con merge: true per aggiornare i campi esistenti
        db.collection("users")
            .document(userId)
            .collection("todos")
            .document(item.id)
            .setData(setItem, merge: true) { error in
                if let error = error {
                    print("Errore nell'aggiornamento del documento: \(error)")
                } else {
                    print("Documento aggiornato con successo")
                }
            }
        
        print("Edit Item Saved")
    }
    
    
    
}
