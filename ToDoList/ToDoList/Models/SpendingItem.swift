import Foundation


struct SpendingItem: Codable, Identifiable {
    
    let id: String
    let amount: Int
    let descriptionText: String
    let operation: String // Typology
    let date: TimeInterval
    let dateTask: TimeInterval
    let category: String // Typology
    let status: String // typology
    
    init(id: String, amount: Int, descriptionText: String, operation: String, date: TimeInterval, dateTask: TimeInterval, category: String, status: String) {
        self.id = id
        self.amount = amount
        self.descriptionText = descriptionText
        self.operation = operation
        self.date = date
        self.dateTask = dateTask
        self.category = category
        self.status = status
    }
    
}
