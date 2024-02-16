import SwiftUI

struct StartView: View {
    
    @State private var navigateToLogin = false
    var haptic = HapticTrigger()
    
    
    var body: some View {
        NavigationView {
            ZStack {
                
                RoundedRectangle(cornerRadius: 0)
                    .fill(Theme.redGradient.gradient)
                
                VStack(spacing: 100) {
                    // Header
                    HeaderView(
                        subTitle: "Let's get things DONE",
                        icon: "checkmark.seal.fill",
                        angle: 0)
                    .offset(y: -5)
                    
                    
                    
                    Button(action: {
                        self.haptic.feedbackHeavy()
                        self.navigateToLogin = true
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Theme.redGradient.gradient)
                                .frame(height: 50)
                            
                            Text("Clicca qui per iniziare")
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                                .foregroundColor(Color.white)
                        }
                    })
                    .frame(width: UIScreen.main.bounds.width / 1.1)
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
                    
                    Spacer()
                    
                    Text("Powered by: Felix")
                        .font(.footnote)
                }
                .fullScreenCover(isPresented: $navigateToLogin, content: {
                    LoginView()
                })
                
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}

