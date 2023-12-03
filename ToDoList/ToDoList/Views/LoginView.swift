import SwiftUI

struct LoginView: View {
    var body: some View {
        
        VStack {
            // Header
            ZStack {
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.96, green: 0.22, blue: 0.31), location: 0.00),
                        Gradient.Stop(color: Color(red: 1, green: 0.01, blue: 0.31), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
                
                VStack {
                    Text("To Do List")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    
                    HStack {
                        Text("Get Things DONE")
                            .foregroundColor(Color.white)
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(Color.white)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: 300)
            
            
            // Login Form
            
            
            // Create Account
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
