import SwiftUI

struct LoginView: View {
    
    var body: some View {
        
        @State var emailField: String = ""
        @State var passField: String = ""
        
        VStack {
            // Header
            HeaderView()
            
            // Login Form
            Form {
                // Email
                TextField("Email", text: $emailField)
                // Password
                SecureField("Password", text: $passField)
                
                // Login Button
                ButtonFormView(textBtn: "Log In")
                    .padding(20)
                
            }
            
            // Create Account
            
            
            Spacer()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
