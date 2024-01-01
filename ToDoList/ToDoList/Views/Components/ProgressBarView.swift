import SwiftUI

struct ProgressBarView: View {
    
    @Binding var valueBar: Double
    @Binding var totalValueBar: Double
    
    var body: some View {
        ProgressView(value: valueBar, total: totalValueBar > 0 ? totalValueBar : 100)
            .frame(width: UIScreen.main.bounds.width, height: 20.0)
            .tint(
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.94, green: 0.31, blue: 0.31), location: 0.00),
                        Gradient.Stop(color: Color(red: 1, green: 0.09, blue: 0.37), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
            )
            .padding(.horizontal)
    }
}

struct ProgressBarView_Preview: PreviewProvider {
    static var previews: some View {
        ProgressBarView(valueBar: .constant(0.5), totalValueBar: .constant(100.0))
    }
}
