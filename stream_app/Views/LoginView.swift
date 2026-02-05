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

            SecureField("Mot de passe", text: $password)
                .textFieldStyle(.roundedBorder)
            
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
            }

            NavigationLink("Créer un compte") {
                RegisterView(authVM: authVM)
            }
        }
        .padding()
    }
}

