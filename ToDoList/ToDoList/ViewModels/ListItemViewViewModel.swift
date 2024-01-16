import Foundation
import FirebaseAuth
import FirebaseFirestore

class ListItemViewViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    init() {}
    
    func toggleIsDone(item: ToDoListItem) {
        var copyItem = item /// trasformo in variabile VAR perchè item è una costante
        copyItem.setDone(!item.isDone) /// item = !item
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        db.collection("users")
            .document(userId)
            .collection("todos")
            .document(copyItem.id) /// booleano modificato
            .setData(copyItem.asDictionary()) /// booleano modificato
    }
}
