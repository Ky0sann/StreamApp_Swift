// Views/RegisterView.swift
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

            Button("S'inscrire") {
                authVM.register(email: email, password: password)
            }
        }
        .padding()
    }
}

