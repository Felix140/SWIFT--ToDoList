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
    
    func delete(idItem: String) {
        
        db.collection("users") /// indicate COLLECTION
            .document(userId) /// passing user ID
            .collection("todos")
            .document(idItem)
            .delete() /// DELETE ITEM
    }
    
    
    func confirmAndDelete() {
        if let item = itemToDelete {
            delete(idItem: item.id)
            itemToDelete = nil
            showingDeleteConfirmation = false
        }
    }
    
    func modifyTask() {
        // Implementare logica di modifica delle task
    }
    
    

}
