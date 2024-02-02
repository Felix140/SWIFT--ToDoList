import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewViewModel()
    var haptic = HapticTrigger()
    
    var body: some View {

        NavigationView {
            VStack {
                Form {
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(Color.red)
                            .font(.subheadline)
                    }
                    
                    TextField("Email", text: $viewModel.emailField)
                        .textInputAutocapitalization(.none)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $viewModel.passField)
                }
                .frame(height: 230)
                .scrollDisabled(true)
                
                
                // Create Account
                VStack {
                    // Login Button
                    ButtonFormView(
                        textBtn: "Log In",
                        action: {
                            self.haptic.feedbackHeavy()
                            viewModel.login()
                        }
                    )
                    .frame(width: UIScreen.main.bounds.width / 1.1)
                    
                    Text("Non hai un account?")
                    
                    /// creo qui un link che mi porta al componente RegisterView()
                    NavigationLink("Clicca qui per creare un Account", destination: RegisterView())
                }
                
                Spacer()
            }
            .navigationTitle("Login")
            .padding(.top, 20)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
