import Foundation

class Notification: Identifiable, Codable {
    
    let id: String
    let sender: User
    let recipient: User
    var isShowed: Bool
    let timeCreation: TimeInterval
    
    init(
        id: String,
        sender: User,
        recipient: User,
        isShowed: Bool,
        timeCreation: TimeInterval
    ) {
        self.id = id
        self.sender = sender
        self.recipient = recipient
        self.isShowed = isShowed
        self.timeCreation = timeCreation
    }
}
