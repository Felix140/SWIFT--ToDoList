import SwiftUI

struct RegisterView: View {
    
    @StateObject var viewModel = RegisterViewViewModel()
    
    var body: some View {
        VStack {
            // Form
            Form {
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(Color.red)
                        .font(.subheadline)
                }
                
                TextField("UserName", text: $viewModel.fullName)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                
                TextField("Email", text: $viewModel.email)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.none)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $viewModel.password)
                SecureField("Repeat Password", text: $viewModel.repeatPass)
                
            }
            .frame(height: 300)
            
            // Register Button
            ButtonFormView(textBtn: "Registrati", action: {
                viewModel.register()
            })
            .frame(width: UIScreen.main.bounds.width / 1.1)
            
            // Login
            VStack {
                Text("Hai già un account?")
                
                /// creo qui un link che mi porta al componente LoginView()
                NavigationLink("Clicca qui Accedere!", destination: LoginView())
            }
            
            Spacer()
        }
        .padding(.top, 50)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
