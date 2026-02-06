import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @ObservedObject var authVM: AuthViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("MovieStream")
                .font(.largeTitle)

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .accessibilityIdentifier("login_email")

            SecureField("Mot de passe", text: $password)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .accessibilityIdentifier("login_password")
            
//            Affichage des messages d'erreurs / réussite
            
            if let success = authVM.successMessage {
                Text(success)
                    .foregroundColor(.green)
                    .transition(.opacity)
            }
            
            if let error = authVM.errorMessageLogin {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }

//            Bouton Login
            Button("Se connecter") {
                authVM.login(email: email, password: password)
            }.accessibilityIdentifier("login_button")

            NavigationLink("Créer un compte") {
                RegisterView(authVM: authVM)
            }.accessibilityIdentifier("go_to_register")
        }
        .padding()
    }
}

