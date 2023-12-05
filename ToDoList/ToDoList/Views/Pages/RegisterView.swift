import SwiftUI

struct RegisterView: View {
    
    @StateObject var viewModel = RegisterViewViewModel()
    
    var body: some View {
        VStack {
            // Header
            HeaderView(title: "Register",
                       subTitle: "Inizia ora ad organizzarti!",
                       icon: "",
                       angle: -15)
            
            // Form
            Form {
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(Color.red)
                        .font(.subheadline)
                }
                
                TextField("UserName", text: $viewModel.fullName)
                    .autocorrectionDisabled()
                TextField("Email", text: $viewModel.email)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.none)
                SecureField("Password", text: $viewModel.password)
                SecureField("Repeat Password", text: $viewModel.repeatPass)
                
                // Register Button
                ButtonFormView(textBtn: "Registrati", action: {
                    viewModel.register()
                })
                    .padding([.bottom, .top])
            }
            .offset(y: -50)
            
            // Login
            VStack {
                Text("Hai già un account?")
                
                /// creo qui un link che mi porta al componente RegisterView()
                NavigationLink("Clicca qui Accedere!", destination: LoginView())
            }
            
            Spacer()
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
