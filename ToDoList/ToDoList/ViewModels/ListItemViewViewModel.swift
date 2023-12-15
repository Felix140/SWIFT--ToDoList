import Foundation
import FirebaseAuth
import FirebaseFirestore

class ListItemViewViewModel: ObservableObject {
    
    init() {}
    
    func toggleIsDone(item: ToDoListItem) {
        var copyItem = item /// trasformo in variabile VAR perchè item è una costante
        copyItem.setDone(!item.isDone) /// item = !item
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        //Update DB
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("ToDos")
            .document(copyItem.id) /// booleano modificato
            .setData(copyItem.asDictionary()) /// booleano modificato
    }
}
