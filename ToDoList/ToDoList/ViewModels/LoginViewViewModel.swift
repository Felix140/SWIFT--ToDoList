import Foundation
import FirebaseAuth /// Da funzionalità per effettuare la Login su Firebase
import WidgetKit

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
        Auth.auth().signIn(withEmail: emailField, password: passField) { [weak self] authResult, err in
            if let error = err {
                print(error.localizedDescription) /// gestione dell'errore
                return
            }
            
            if let user = authResult?.user {
                let defaults = UserDefaults(suiteName: "group.com.felixvaldez.ToDoList")
                defaults?.set(user.uid, forKey: "currentUserIdKey")
                // Aggiorna l'interfaccia utente o compi altre azioni necessarie
            }
        }
        WidgetCenter.shared.reloadTimelines(ofKind: "TooDooWidget")
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
