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



// Dizionario che mappa le categorie ai temi

let categoryThemeMap: [CategoryTask: UserTheme] = [
    .work: .indigo,
    .study: .poppy,
    .home: .orange,
    .project: .oxblood,
    .creativity: .magenta
]

// Funzione che restituisce il colore del tema basato sulla categoria
func themeColorForCategory(category: CategoryTask) -> Color {
    /// Ottieni il tema corrispondente alla categoria, altrimenti usa un tema di default
    let theme = categoryThemeMap[category] ?? .navy /// Utilizza un tema di default se non presente
    return theme.mainColor
}
