import Foundation


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
        
        print("Registrazione avvenuta")
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
