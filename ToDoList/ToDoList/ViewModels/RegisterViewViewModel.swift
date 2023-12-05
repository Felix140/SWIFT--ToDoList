import Foundation
import FirebaseAuth /// Da funzionalità per effettuare la Login su Firebase
import FirebaseFirestore


class RegisterViewViewModel: ObservableObject {
    
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var repeatPass = ""
    @Published var errorMessage = ""
    
    init() {}
    
    func register() {
        guard validate() else {
            return
        }
        
        // Effettua la registrazione
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] userResult, error in
            guard let userId = userResult?.user.uid else { /// [weak self] evita che si verificano dei memory leak
                return
            }
            
            self?.insertUserRecord(id: userId)
        }
        
        print("Registrazione avvenuta")
    }
    
    // Inserisce l'utente dentro il FireStore DB
    private func insertUserRecord(id: String) {
        
        var newUser = User( 
            id: id,
            name: fullName,
            email: email,
            joined: Date().timeIntervalSince1970)
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
     }
    
    
    func validate() -> Bool {
        errorMessage = ""
        /// CHECK verifica se i campi input NON sono vuoti
        guard !fullName.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              !repeatPass.trimmingCharacters(in: .whitespaces).isEmpty else {
            
            errorMessage = "Riempi i campi testo."
            print("testo da riempire")
            
            return false
        }
        /// CHECK verifica se il campo input email contiene "@" oppure il punto "."
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Inserisci un Email valida."
            if !email.contains("@") {
                print("Email non contiene @")
            }
            if !email.contains(".") {
                print("Email non contiene il punto")
            }
            return false
        }
        /// CHECK verifica se i campi password e repeatPass coincidono
        guard password.count >= 8 else {
            errorMessage = "La password deve essere di almeno 8 caratteri"
            return false
        }
        /// CHECK verifica se i campi password e repeatPass coincidono
        if repeatPass != password {
            errorMessage = "Inserisci correttamente la password da verificare"
            return false
        }
        
        return true
    }
}
