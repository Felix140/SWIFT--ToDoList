import Foundation

struct ToDoListItem: Identifiable, Codable {
    let id: String
    let title: String
    let dueDate: TimeInterval
    let createdDate: TimeInterval
    var isDone: Bool
    var pomodoro: Bool
    let category: CategoryTask
    let description: String
   
    init(id: String, title: String, dueDate: TimeInterval, createdDate: TimeInterval, isDone: Bool, pomodoro: Bool, category: CategoryTask, description: String) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.createdDate = createdDate
        self.isDone = isDone
        self.pomodoro = pomodoro
        self.category = category
        self.description = description
    }
    
    mutating func setDone(_ state: Bool) {
        isDone = state
    }
}
