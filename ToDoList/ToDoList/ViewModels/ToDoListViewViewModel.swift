import Foundation
import FirebaseFirestore

class ToDoListViewViewModel: ObservableObject {
    
    @Published var isPresentingView: Bool = false
    @Published var isOpenDescription: Bool = false
    private var userId: String
    let db = Firestore.firestore()
    
    init(userId: String) {
        self.userId = userId
    }
    
    func delete(idItem: String) {
        
        db.collection("users") /// indicate COLLECTION
            .document(userId) /// passing user ID
            .collection("todos")
            .document(idItem)
            .delete() /// DELETE ITEM
    }
}
