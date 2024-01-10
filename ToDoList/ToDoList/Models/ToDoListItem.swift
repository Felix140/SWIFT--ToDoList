import Foundation

struct ToDoListItem: Identifiable, Codable {
    let id: String
    let title: String
    let dueDate: TimeInterval
    let createdDate: TimeInterval
    var isDone: Bool
    let category: CategoryTask
    let description: InfoToDoItem
   
    init(id: String, title: String, dueDate: TimeInterval, createdDate: TimeInterval, isDone: Bool, category: CategoryTask, description: InfoToDoItem) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.createdDate = createdDate
        self.isDone = isDone
        self.category = category
        self.description = description
    }
    
    mutating func setDone(_ state: Bool) {
        isDone = state
    }
}
