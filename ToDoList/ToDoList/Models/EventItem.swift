import Foundation

struct EventItem: Identifiable, Codable {
    
    let id: String
    let title: String
    let startDate: TimeInterval
    let endDate: TimeInterval
    let createdDate: TimeInterval
    var category: CategoryTask
    var description: InfoToDoItem
    
    init(id: String, title: String, startDate: TimeInterval, endDate: TimeInterval, createdDate: TimeInterval, category: CategoryTask, description: InfoToDoItem) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.createdDate = createdDate
        self.category = category
        self.description = description
    }
}
