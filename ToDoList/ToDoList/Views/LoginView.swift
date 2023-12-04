import SwiftUI

struct LoginView: View {
    
    var body: some View {
        
        @State var emailField: String = ""
        @State var passField: String = ""
        
        NavigationView {
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
                        .padding([.top, .bottom], 20)
                    
                }
                
                // Create Account
                VStack {
                    Text("Non hai un account?")
                    
                    /// creo qui un link che mi porta al componente RegisterView()
                    NavigationLink("Clicca qui per creare un Account", destination: RegisterView())
                }
                
                
                Spacer()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
