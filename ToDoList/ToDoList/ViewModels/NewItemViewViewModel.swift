import Foundation

class NewItemViewViewModel: ObservableObject {
    
    @Published var title = ""
    @Published var date = Date()
    @Published var showAlert = false
    
    init() {}
    
    func save() {
        print("New Item Saved")
    }
    
    /// Check dei campi prima del salvataggio
    func canSave() -> Bool {
        
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("Riempi il titolo")
            return false
        }
        
        ///Check su  DATE >= di IERI ( giorno corrente: Date(), sottratto da -86400: ovver secondi in un giorno )
        guard date >= Date().addingTimeInterval(-86400) else {
            print("Giorno non Valido")
            return false
        }
        
        return true
    }
    
    
}
