import SwiftUI

enum CategoryTask: String, Codable, CaseIterable {
    
    case none
    case work
    case study
    case home
    case project
    case creativity
    
    var categoryName: String {
        switch self {
        case .none: return "None"
        case .work: return "Work"
        case .study: return "Study"
        case .home: return "Home"
        case .project: return "Project"
        case .creativity: return "Creativity"
        }
    }
}
