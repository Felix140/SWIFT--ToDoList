import Foundation

struct Notification: Identifiable, Codable {
    
    let id: String
    let sender: String
    var senderName: String
    let recipient: String
    let task: ToDoListItem
    var isAccepted: Bool
    
    
    init(id: String, sender: String, senderName: String, recipient: String, task: ToDoListItem, isAccepted: Bool) {
        self.id = id
        self.sender = sender
        self.senderName = senderName
        self.recipient = recipient
        self.task = task
        self.isAccepted = isAccepted
    }
    
    
    mutating func setAccepted(_ state: Bool) {
        isAccepted = state
    }
}
