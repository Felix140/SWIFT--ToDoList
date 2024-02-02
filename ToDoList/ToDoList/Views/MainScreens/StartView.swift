import SwiftUI

struct StartView: View {
    
    @State private var navigateToLogin = false
    var haptic = HapticTrigger()
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 100) {
                // Header
                HeaderView(title: "TooDoo",
                           subTitle: "Let's get things DONE",
                           icon: "checkmark.seal.fill",
                           angle: 0)
                .offset(y: -20)
                
                Button(action: { 
                    self.haptic.feedbackHeavy()
                    self.navigateToLogin = true
                }, label: {
                    ZStack {
                        Rectangle()
                            .fill(Theme.redGradient.gradient)
                            .cornerRadius(15.0)
                            .frame(height: 50)
                        
                        Text("Clicca qui per iniziare")
                            .font(.system(size: 20))
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                    }
                })
                .frame(width: UIScreen.main.bounds.width / 1.1)
                
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

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}

