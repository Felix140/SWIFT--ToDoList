import Foundation

struct Notification: Identifiable, Codable {
    
    let id: String
    let sender: User
    let recipient: User
    let task: ToDoListItem
    var isAccepted: Bool
    var isShowed: Bool
    let timeCreation: TimeInterval
    
    
    init(id: String, sender: User, recipient: User, task: ToDoListItem, isAccepted: Bool, isShowed: Bool, timeCreation: TimeInterval) {
        self.id = id
        self.sender = sender
        self.recipient = recipient
        self.task = task
        self.isAccepted = isAccepted
        self.isShowed = isShowed
        self.timeCreation = timeCreation
    }
    
    
    mutating func setAccepted(_ state: Bool) {
        isAccepted = state
    }
}
