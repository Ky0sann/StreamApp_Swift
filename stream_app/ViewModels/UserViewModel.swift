import Foundation

@MainActor
class UserViewModel: ObservableObject {
    @Published var user: User

    private let authService = AuthService()

    init() {
        self.user = authService.getUser() ?? User(email: "test@example.com", username: "Utilisateur")
    }

    func updateUser(username: String, bio: String) {
        user.username = username
        user.bio = bio
        authService.saveUser(user: user)
    }
}

