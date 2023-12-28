import SwiftUI

struct StartView: View {
    
    @State private var navigateToLogin = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 100) {
                // Header
                HeaderView(title: "TooDoo",
                           subTitle: "Let's get things DONE",
                           icon: "checkmark.seal.fill",
                           angle: 10)
                .offset(y: -90)
                
                Button(action: { 
                    self.navigateToLogin = true
                }, label: {
                    ZStack {
                        Rectangle()
                            .overlay(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.94, green: 0.31, blue: 0.31), location: 0.00),
                                        Gradient.Stop(color: Color(red: 1, green: 0.09, blue: 0.37), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 0.5, y: 0),
                                    endPoint: UnitPoint(x: 0.5, y: 1)
                                )
                            )
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
                
                Text("Powered by FelixSPA")
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

