import SwiftUI

struct ProgressBarView: View {
    
    @Binding var valueBar: Double
    @Binding var totalValueBar: Double
    
    var body: some View {
        ProgressView(value: valueBar, total: totalValueBar > 0 ? totalValueBar : 100)
            .frame(width: UIScreen.main.bounds.width, height: 20.0)
            .tint(Theme.redGradient.gradient)
            .padding(.horizontal)
    }
}

struct ProgressBarView_Preview: PreviewProvider {
    static var previews: some View {
        ProgressBarView(valueBar: .constant(0.5), totalValueBar: .constant(100.0))
    }
}
