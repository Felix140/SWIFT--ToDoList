import Foundation

struct UserContacts: Identifiable, Codable {
    let id: String
    let contacts: [User]
    
    init(id: String, contacts: [User]) {
        self.id = id
        self.contacts = contacts
    }
}