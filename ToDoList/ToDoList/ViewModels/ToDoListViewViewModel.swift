import Foundation
import FirebaseFirestore

class ToDoListViewViewModel: ObservableObject {
    
    @Published var isPresentingView: Bool = false
    @Published var isOpenPomodoroModel: Bool = false
    @Published var isOnPomodoro: Bool = false
    private var userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    func delete(idItem: String) {
        let db = Firestore.firestore() /// import DATABASE
        db.collection("users") /// indicate COLLECTION
            .document(userId) /// passing user ID
            .collection("ToDos")
            .document(idItem)
            .delete() /// DELETE ITEM
    }
}
