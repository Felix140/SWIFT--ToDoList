import Foundation

/// La ViewModel astrae tutta la logica della View

class LoginViewViewModel: ObservableObject {
    
    @Published var emailField = ""
    @Published var passField = ""
    
    init() {}
    
    /// Creo qui le funzionalità della LOGIN
    
    func login() {
        
    }
    
    func validate() {
        
    }
}
