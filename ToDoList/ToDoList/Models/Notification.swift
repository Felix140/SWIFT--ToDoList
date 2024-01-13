import Foundation

struct Notification: Identifiable, Codable {
    
    let id: String
    let sender: User
    let recipient: User
    let task: ToDoListItem
    var isAccepted: Bool
    
    
    init(id: String, sender: User, recipient: User, task: ToDoListItem, isAccepted: Bool) {
        self.id = id
        self.sender = sender
        self.recipient = recipient
        self.task = task
        self.isAccepted = isAccepted
    }
    
    
    mutating func setAccepted(_ state: Bool) {
        isAccepted = state
    }
}
