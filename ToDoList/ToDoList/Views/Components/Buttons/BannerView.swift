import SwiftUI


struct BannerView: View {
    
    @State var testMessage: String
    @State var colorBanner: Color
    @Binding var showBanner:  Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(colorBanner)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                .shadow(radius: 10)
            Text(testMessage)
                .foregroundColor(.white)
        }
        .edgesIgnoringSafeArea(.top)
        .padding(.top, UIScreen.main.bounds.height / 75)
        .transition(.asymmetric(insertion: .opacity.combined(with: .slide), removal: .scale.combined(with: .opacity)))
        .animation(.easeInOut(duration: 0.5), value: showBanner)
        .zIndex(1)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showBanner = false
                }
            }
        }
    }
}

struct BannerView_Preview: PreviewProvider {
    static var previews: some View {
        BannerView(testMessage: "Testo esempio", colorBanner: .blue, showBanner: .constant(false))
    }
}
