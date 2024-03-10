import Foundation

class TaskNotification: Notification {
    
    let task: ToDoListItem
    var isAccepted: Bool
    
    enum CodingKeys: String, CodingKey {
        case task, isAccepted
    }
    
    required init(
        from decoder: Decoder
    ) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.task = try container.decode(ToDoListItem.self, forKey: .task)
        self.isAccepted = try container.decode(Bool.self, forKey: .isAccepted)
        /// Chiama l'inizializzatore della superclasse
        try super.init(from: decoder)
    }
    
    init(
        id: String,
        sender: User,
        recipient: User,
        isShowed: Bool,
        timeCreation: TimeInterval,
        task: ToDoListItem,
        isAccepted: Bool
    ) {
        self.task = task
        self.isAccepted = isAccepted
        super.init(
            id: id,
            sender: sender,
            recipient: recipient,
            isShowed: isShowed,
            timeCreation: timeCreation)
    }
}
