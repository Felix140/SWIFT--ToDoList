import SwiftUI

struct RegisterView: View {
    
    @StateObject var viewModel = RegisterViewViewModel()
    var haptic = HapticTrigger()
    
    var body: some View {
        VStack {
            // Form
            Form {
                Section {
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
            }
            .frame(height: 230)
            .scrollDisabled(true)
            
            
            
            // Register Button
            ButtonFormView(
                textBtn: "Registrati",
                action: {
                    self.haptic.feedbackHeavy()
                    viewModel.register()
                })
            .frame(width: UIScreen.main.bounds.width / 1.1)
            
            
            
            Spacer()
        }
        .navigationTitle("Registration")
        .padding(.top, 20)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
