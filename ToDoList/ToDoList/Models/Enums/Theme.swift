import SwiftUI

enum Theme {
    
    case redGradient
    
    var gradient: LinearGradient {
        switch self {
        case .redGradient:
            return LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.94, green: 0.31, blue: 0.31), location: 0.00),
                    Gradient.Stop(color: Color(red: 1, green: 0.09, blue: 0.37), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
        }
    }
}
