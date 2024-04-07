import Foundation


struct SpendingItem: Codable, Identifiable {
    
    let id: String
    let amount: Int
    let descriptionText: String
    let spendingType: SpendingTypology
    let creationDate: TimeInterval
    let dateTask: TimeInterval
    let category: CategorySpending
    let status: StatusTypology
    
    init(id: String, amount: Int, descriptionText: String, spendingType: SpendingTypology, creationDate: TimeInterval, dateTask: TimeInterval, category: CategorySpending, status: StatusTypology) {
        self.id = id
        self.amount = amount
        self.descriptionText = descriptionText
        self.spendingType = spendingType
        self.creationDate = creationDate
        self.dateTask = dateTask
        self.category = category
        self.status = status
    }
}
