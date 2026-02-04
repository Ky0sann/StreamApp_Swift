// ViewModels/AuthViewModel.swift
import Foundation

class AuthViewModel: ObservableObject {
    @Published var isLogged: Bool = false

    private let authService = AuthService()

    init() {
        isLogged = authService.isLogged()
    }

    func login(email: String, password: String) {
        isLogged = authService.login(email: email, password: password)
    }

    func register(email: String, password: String) {
        isLogged = authService.register(email: email, password: password)
    }

    func logout() {
        authService.logout()
        isLogged = false
    }
}

