import Foundation

struct ToDoListItem: Identifiable, Codable {
    let id: String
    let title: String
    let dueDate: TimeInterval
    let createdDate: TimeInterval
    let isDone: Bool
   
    init(id: String, title: String, dueDate: TimeInterval, createdDate: TimeInterval, isDone: Bool) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.createdDate = createdDate
        self.isDone = isDone
    }
    
    mutating func setDone(_ state: Bool) -> Bool {
        return state
    }
}
