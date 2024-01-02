import SwiftUI

struct TimerArc: Shape {
    var progress: Double

    func path(in rect: CGRect) -> Path {
        let diameter = min(rect.size.width, rect.size.height) - 24.0
        let radius = diameter / 2.0
        let center = CGPoint(x: rect.midX, y: rect.midY)

        // Inizia dalla posizione delle 12
        let startAngle = Angle(degrees: -90)
        // Calcola la fine dell'arco in modo che diminuisca con il progresso
        let endAngle = Angle(degrees: -90 + (360 * (1 - progress)))

        return Path { path in
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        }
    }
}
