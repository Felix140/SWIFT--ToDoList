import Foundation
import FirebaseAuth

class MainViewViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        
        //        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
        //            DispatchQueue.main.async {
        //                self?.currentUserId = user?.uid ?? ""
        //            }
        //        }
        
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                if let userID = user?.uid {
                    let defaults = UserDefaults(suiteName: "group.com.felixvaldez.ToDoList")
                    defaults?.set(userID, forKey: "currentUserIdKey")
                } else {
                    let defaults = UserDefaults(suiteName: "group.com.felixvaldez.ToDoList")
                    defaults?.removeObject(forKey: "currentUserIdKey")
                }
                self?.currentUserId = user?.uid ?? ""
            }
        }
    }
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil /// se NON è nil (quindi se è presente un valore) il risultato è TRUE
    }
}
