import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @ObservedObject var authVM: AuthViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Inscription")
                .font(.title)

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)

            SecureField("Mot de passe", text: $password)
                .textFieldStyle(.roundedBorder)
            
            if let error = authVM.errorMessageLogin {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button("S'inscrire") {
                authVM.register(email: email, password: password)
            }
        }
        .padding()
    }
}

