import Foundation

/// La ViewModel astrae tutta la logica della View

class LoginViewViewModel: ObservableObject {
    
    @Published var emailField = ""
    @Published var passField = ""
    @Published var errorMessage = ""
    
    init() {}
    
    /// Creo qui le funzionalità della LOGIN
    
    func login() {
        /// resetta il messaggio di Errore
        errorMessage = ""
        
        /// CHECK verifica se i campi input NON sono vuoti
        guard !emailField.trimmingCharacters(in: .whitespaces).isEmpty,
                !passField.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Riempi i campi testo."
            print("testo da riempire")
            return
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
            
            return
        }
        
        print("Login effettuato")
    }
    
    func validate() {
        
    }
}
