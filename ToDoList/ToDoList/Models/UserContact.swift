import Foundation
import FirebaseAuth


class UserContact: User {
    var isSaved: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, joined, isSaved
    }
    
    /**
       `required init(from decoder: Decoder) throws` è un inizializzatore richiesto per conformità al protocollo `Decodable`.
       Questo inizializzatore consente alla classe `UserContact` di inizializzare le sue proprietà da una rappresentazione esterna
       (ad esempio, un documento JSON) durante il processo di decodifica.

       - Parameters:
         - decoder: Un'istanza di `Decoder` che fornisce un contesto per la decodifica di valori dal formato esterno.

       Il metodo decodifica le proprietà `id`, `name`, `email`, `joined` e `isSaved` usando il `decoder`.
       È richiesto per garantire che tutte le istanze di `UserContact`, incluse quelle delle sottoclassi, possano essere decodificate correttamente.

       Nota: Viene chiamato l'inizializzatore della superclasse `User` per completare la decodifica delle proprietà ereditate.
    */
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Decodifica ogni proprietà usando il decoder
        _ = try container.decode(String.self, forKey: .id)
        _ = try container.decode(String.self, forKey: .name)
        _ = try container.decode(String.self, forKey: .email)
        _ = try container.decode(TimeInterval.self, forKey: .joined)
        self.isSaved = try container.decode(Bool.self, forKey: .isSaved)
        
        // Non dimenticare di chiamare l'inizializzatore della superclasse!
        try super.init(from: decoder)
    }
    
    init(id: String, name: String, email: String, joined: TimeInterval, isSaved: Bool) {
        self.isSaved = isSaved
        super.init(id: id, name: name, email: email, joined: joined)
    }
    
}
