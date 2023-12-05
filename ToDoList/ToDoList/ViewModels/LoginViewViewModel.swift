import Foundation
import FirebaseAuth /// Da funzionalità per effettuare la Login su Firebase

/// La ViewModel astrae tutta la logica della View

class LoginViewViewModel: ObservableObject {
    
    @Published var emailField = ""
    @Published var passField = ""
    @Published var errorMessage = ""
    
    init() {}
    
    /// Creo qui le funzionalità della LOGIN
    
    func login() {
        
        // Funzionalità di CHECK
        guard validate() else {
            return /// Se non si effettua la validazione si Stoppa ed esce fuori
        }
        
        //Effettua la login
        Auth.auth().signIn(withEmail: emailField, password: passField)
        
        print("Login effettuato")
    }
    
    func validate() -> Bool {
        /// resetta il messaggio di Errore
        errorMessage = ""
        
        /// CHECK verifica se i campi input NON sono vuoti
        guard !emailField.trimmingCharacters(in: .whitespaces).isEmpty,
                !passField.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Riempi i campi testo."
            print("testo da riempire")
            return false
        }
        
        /// CHECK verifica se il campo input email contiene "@" oppure il punto "."
        guard emailField.contains("@") && emailField.contains(".") else {
            errorMessage = "Inserisci un Email valida."
            
            if !emailField.contains("@") {
                print("Email non contiene @")
            }
            if !emailField.contains(".") {
                print("Email non contiene il punto")
            }
            
            return false
        }
        
        return true
    }
}
