import Foundation

class AuthService {
    private let userKey = "USER_LOGGED"

    func login(email: String, password: String) -> Bool {
        if email.isEmpty || password.isEmpty { return false }
        UserDefaults.standard.set(true, forKey: userKey)
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
}

