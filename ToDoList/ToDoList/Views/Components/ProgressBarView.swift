import SwiftUI

struct ProgressBarView: View {
    
    var valueBar: Double
    var totalValueBar: Double
    
    var body: some View {
        ProgressView(value: valueBar, total: totalValueBar > 0 ? totalValueBar : 100)
            .frame(width: UIScreen.main.bounds.width, height: 20.0)
            .tint(Theme.redGradient.gradient)
            .padding(.horizontal)
            .animation(.linear(duration: 2.6), value: valueBar)
    }
}

struct ProgressBarView_Preview: PreviewProvider {
    static var previews: some View {
        ProgressBarView(valueBar: 0.5, totalValueBar: 100.0)
    }
}
