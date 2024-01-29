import Foundation

//struct User: Codable, Identifiable, Hashable {
//    let id: String
//    let name: String
//    let email: String
//    let joined: TimeInterval
//    
//    init(id: String, name: String, email: String, joined: TimeInterval) {
//        self.id = id
//        self.name = name
//        self.email = email
//        self.joined = joined
//    }
//}


class User: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let email: String
    let joined: TimeInterval

    init(id: String, name: String, email: String, joined: TimeInterval) {
        self.id = id
        self.name = name
        self.email = email
        self.joined = joined
    }

    // Implementazione necessaria per conformità a Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // Implementazione necessaria per conformità a Equatable
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

