import Foundation

extension Encodable {
    
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:] /// Dizionario Vuoto
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json ?? [:] ///ritorna un Dizionario ALTRIMENTI un Dizionario Vuoto
        } catch {
            return [:] /// Dizionario Vuoto
        }
    }
}
