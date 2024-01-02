import SwiftUI

struct TimerView: View {
    var progress: Double

    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(lineWidth: 24)
                .overlay {
                    VStack {
                        Text("Pomodoro")
                    }
                    .accessibilityElement(children: .combine)
                }
                .overlay {
                    TimerArc(progress: progress)
                        .rotation(Angle(degrees: 0)) 
                        .stroke(Color.blue, lineWidth: 12)
                }
                .padding(.horizontal)
        }
    }
}

struct TimerView_Preview: PreviewProvider {
    static var previews: some View {
        TimerView(progress: 1.0)
    }
}
