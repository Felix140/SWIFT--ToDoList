import Foundation
import FirebaseAuth


class UserContact: User {
    
    var isSaved: Bool
    
    enum CodingKeys: String, CodingKey {
        case isSaved
    }
    
    /**
     `required init(from decoder: Decoder) throws` è un inizializzatore richiesto per conformità al protocollo `Decodable`.
     Questo inizializzatore consente alla classe `UserContact` di inizializzare le sue proprietà da una rappresentazione esterna
     (ad esempio, un documento JSON) durante il processo di decodifica.
     
     - Parameters:
     - decoder: Un'istanza di `Decoder` che fornisce un contesto per la decodifica di valori dal formato esterno.
     
     Il metodo decodifica la proprietà `isSaved` usando il `decoder`.
     È richiesto per garantire che tutte le istanze di `UserContact`, incluse quelle delle sottoclassi, possano essere decodificate correttamente.
     
     Nota: Viene chiamato l'inizializzatore della superclasse `User` per completare la decodifica delle proprietà ereditate.
     */
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isSaved = try container.decode(Bool.self, forKey: .isSaved)
        // Chiama l'inizializzatore della superclasse
        try super.init(from: decoder)
    }
    
    init(
        id: String,
        name: String,
        email: String,
        joined: TimeInterval,
        isSaved: Bool
    ) {
        self.isSaved = isSaved
        super.init(id: id, name: name, email: email, joined: joined)
    }
    
}
