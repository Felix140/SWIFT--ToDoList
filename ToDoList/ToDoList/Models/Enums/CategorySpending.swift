import SwiftUI

enum CategorySpending: String, Codable, CaseIterable {
    
    case none
    case transportation
    case housing
    case utilities
    case food
    case healthCare
    case insurance
    case personal
    case entertainment
    
    
    var categoryName: String {
        switch self {
        case .none : return "none"
        case .transportation : return "transportation"
        case .housing : return "housing"
        case .utilities : return "utilities"
        case .food : return "food"
        case .healthCare : return "health care"
        case .insurance : return "insurance"
        case .personal : return "personal"
        case .entertainment : return "entertainment"
        }
    }
}
