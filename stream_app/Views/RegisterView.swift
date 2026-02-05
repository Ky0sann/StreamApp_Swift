import SwiftUI

struct RegisterView: View {
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @ObservedObject var authVM: AuthViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Inscription")
                .font(.title)
            
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
            
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

            
//            Bouton Register
            Button("S'inscrire") {
                authVM.register(username:username ,email: email, password: password)
            }
        }
        .padding()
    }
}

