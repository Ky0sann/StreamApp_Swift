import Foundation

class AuthService {

    private let storage = UserStorageService()
    private let loggedUserEmailKey = "LOGGED_USER_EMAIL"

    // MARK: - LOGIN
    func login(email: String, password: String) -> Bool {
        guard !email.isEmpty, !password.isEmpty else { return false }

        guard storage.userExists(email: email) else {
            return false
        }

        UserDefaults.standard.set(email, forKey: loggedUserEmailKey)
        return true
    }

    // MARK: REGISTER
    func register(email: String, password: String) -> Bool {
        guard !email.isEmpty, !password.isEmpty else { return false }

        guard !storage.userExists(email: email) else {
            return false
        }

        let user = User(
            email: email,
            username: email.components(separatedBy: "@").first ?? email
        )

        storage.addUser(user)
        UserDefaults.standard.set(email, forKey: loggedUserEmailKey)
        return true
    }

    // MARK: LOGOUT
    func logout() {
        UserDefaults.standard.removeObject(forKey: loggedUserEmailKey)
    }

    // MARK: SESSION
    func isLogged() -> Bool {
        UserDefaults.standard.string(forKey: loggedUserEmailKey) != nil
    }

    func getUser() -> User? {
        guard let email = UserDefaults.standard.string(forKey: loggedUserEmailKey) else {
            return nil
        }
        return storage.getUser(email: email)
    }

    // MARK: SAVE USER
    func saveUser(user: User) {
        var users = storage.loadUsers()

        if let index = users.firstIndex(where: { $0.email.lowercased() == user.email.lowercased() }) {
            users[index] = user
        } else {
            users.append(user)
        }

        storage.saveUsers(users)
    }
}
