import SwiftUI

enum UserTheme: String, CaseIterable, Identifiable, Codable {
    
    case bubbleGum
    case butterCup
    case indigo
    case lavender
    case magenta
    case navy
    case orange
    case oxblood
    case periwinkle
    case poppy
    case purple
    case seafoam
    case sky
    case tan
    case teal
    case yellow
    
    
    var accentColor: Color {
        switch self {
        case .bubbleGum, .butterCup, .lavender, .orange, .periwinkle, .poppy, .seafoam, .sky, .tan, .teal, .yellow: return .black
        case .indigo, .magenta, .navy, .oxblood, .purple: return .white
        }
    }
    
//    var mainColor: Color {
//        Color(rawValue)
//    }
    
    var mainColor: Color {
        switch self {
        case .bubbleGum:
            return Color(.sRGB, red: 240/255, green: 99/255, blue: 164/255, opacity: 1)
        case .butterCup:
            return Color(.sRGB, red: 255/255, green: 175/255, blue: 84/255, opacity: 1)
        case .indigo:
            return Color(.sRGB, red: 63/255, green: 81/255, blue: 181/255, opacity: 1)
        case .lavender:
            return Color(.sRGB, red: 200/255, green: 200/255, blue: 255/255, opacity: 1)
        case .magenta:
            return Color(.sRGB, red: 255/255, green: 64/255, blue: 129/255, opacity: 1)
        case .navy:
            return Color(.sRGB, red: 33/255, green: 33/255, blue: 33/255, opacity: 1)
        case .orange:
            return Color(.sRGB, red: 255/255, green: 124/255, blue: 0/255, opacity: 1)
        case .oxblood:
            return Color(.sRGB, red: 98/255, green: 0/255, blue: 36/255, opacity: 1)
        case .periwinkle:
            return Color(.sRGB, red: 179/255, green: 200/255, blue: 255/255, opacity: 1)
        case .poppy:
            return Color(.sRGB, red: 255/255, green: 60/255, blue: 60/255, opacity: 1)
        case .purple:
            return Color(.sRGB, red: 103/255, green: 58/255, blue: 183/255, opacity: 1)
        case .seafoam:
            return Color(.sRGB, red: 32/255, green: 201/255, blue: 151/255, opacity: 1)
        case .sky:
            return Color(.sRGB, red: 77/255, green: 208/255, blue: 225/255, opacity: 1)
        case .tan:
            return Color(.sRGB, red: 234/255, green: 191/255, blue: 147/255, opacity: 1)
        case .teal:
            return Color(.sRGB, red: 90/255, green: 200/255, blue: 250/255, opacity: 1)
        case .yellow:
            return Color(.sRGB, red: 255/255, green: 238/255, blue: 88/255, opacity: 1)
        }
    }
    
    var nameColor: String {
        rawValue.capitalized // La funzione .capitalized trasforma la prima lettera di una stringa in maiuscolo e lascia le altre lettere in minuscolo.
    }
    
    var id: String {
        nameColor
    }
}
