import SwiftUI

struct RegisterView: View {
    
    @State var fullName = ""
    @State var email = ""
    @State var password = ""
    @State var repeatPass = ""
    
    var body: some View {
        VStack {
            // Header
            HeaderView(title: "Register",
                       subTitle: "Inizia ora ad organizzarti!",
                       icon: "",
                       angle: -15)
            
            // Form
            Form {
                TextField("UserName", text: $fullName)
                    .autocorrectionDisabled()
                TextField("Email", text: $email)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.none)
                SecureField("Password", text: $password)
                SecureField("Repeat Password", text: $repeatPass)
                
                // Register Button
                ButtonFormView(textBtn: "Registrati", action: {
                    
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
