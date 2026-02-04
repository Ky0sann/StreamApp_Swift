import Foundation

class AuthService {
    private let userKey = "USER_LOGGED"
    private let userDataKey = "USER_DATA"

    func login(email: String, password: String) -> Bool {
        if email.isEmpty || password.isEmpty { return false }
        UserDefaults.standard.set(true, forKey: userKey)

        // Si l'utilisateur n'existe pas encore, créer un User par défaut
        if getUser() == nil {
            let user = User(email: email, username: email.components(separatedBy: "@").first ?? email)
            saveUser(user: user)
        }

        return true
    }

    func register(email: String, password: String) -> Bool {
        login(email: email, password: password)
    }

    func logout() {
        UserDefaults.standard.set(false, forKey: userKey)
    }

    func isLogged() -> Bool {
        UserDefaults.standard.bool(forKey: userKey)
    }

    func saveUser(user: User) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: userDataKey)
        }
    }

    func getUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: userDataKey) else { return nil }
        return try? JSONDecoder().decode(User.self, from: data)
    }
}

