import Foundation
import FirebaseAuth
import FirebaseFirestore
import WidgetKit

class ProfileViewViewModel: ObservableObject {
    
    @Published var user: User? = nil
    let db = Firestore.firestore()
    
    init() {}
    
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        // Fetching User
        db.collection("users")
            .document(userId)
            .getDocument { [weak self] snapshot, error in
                guard let data = snapshot?.data(), error == nil else {
                    return /// assegnamo l'oggetto a userId
                }
                
                DispatchQueue.main.async {
                    self?.user = User(
                        id: data["id"] as? String ?? "",
                        name: data["name"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        joined: data["joined"] as? TimeInterval ?? 0
                    )
                }
            }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut() /// Metodo di FirebaseAuth
        } catch {
            print(error)
        }
        WidgetCenter.shared.reloadTimelines(ofKind: "TooDooWidget")
    }
}
