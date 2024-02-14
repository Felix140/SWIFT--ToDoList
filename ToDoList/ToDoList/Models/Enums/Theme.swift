import SwiftUI

enum Theme {
    
    case redGradient
    case red
    
    var gradient: LinearGradient {
        switch self {
        case .redGradient:
            return LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 1, green: 0.04, blue: 0.32), location: 0.27),
                    Gradient.Stop(color: Color(red: 0.93, green: 0.06, blue: 0.38), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
        case .red:
            return LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 1, green: 0.04, blue: 0.32), location: 0.27),
                    Gradient.Stop(color: Color(red: 1, green: 0.04, blue: 0.32), location: 0.27),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
        }
    }
}
