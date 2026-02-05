import Foundation

class AuthService {

    private let storage = UserStorageService()
    private let loggedUserEmailKey = "LOGGED_USER_EMAIL"
    
    private(set) var errorMessageLogin: String? 
    private(set) var successMessage: String?

    // MARK: - LOGIN
    func login(email: String, password: String) -> Bool {
        errorMessageLogin = nil
        successMessage = nil
        
        guard !email.isEmpty, !password.isEmpty else {
            errorMessageLogin = "Veillez remplir tous les champs"
            return false
        }
        
        guard email.contains("@") else {
            errorMessageLogin = "L’adresse email doit contenir @."
            return false
        }

        guard storage.userExists(email: email) else {
            errorMessageLogin = "Adresse mail ou mot de passe incorrect"
            return false
        }

        UserDefaults.standard.set(email, forKey: loggedUserEmailKey)
        successMessage = "Connexion réussie"
        
        return true
    }

    
    
    func register(username:String, email: String, password: String) -> Bool {
        errorMessageLogin = nil
        successMessage = nil
        
        guard !email.isEmpty, !password.isEmpty else {
            errorMessageLogin = "Veuillez remplir tous les champs."
            return false
        }

        guard email.contains("@") else {
            errorMessageLogin = "L’adresse email doit contenir @."
            return false
        }

        guard hasUppercase(password) else {
            errorMessageLogin = "Le mot de passe doit contenir au moins une majuscule."
            return false
        }

        guard hasLowercase(password) else {
            errorMessageLogin = "Le mot de passe doit contenir au moins une minuscule."
            return false
        }

        guard hasDigit(password) else {
            errorMessageLogin = "Le mot de passe doit contenir au moins un chiffre."
            return false
        }

        guard hasSpecialCharacter(password) else {
            errorMessageLogin = "Le mot de passe doit contenir au moins un caractère spécial."
            return false
        }

        guard !storage.userExists(email: email) else {
            errorMessageLogin = "Cette adresse mail est déjà utilisée."
            return false
        }

        let user = User(
            email: email,
            username: username,
            password: String(password.hashValue)
            
        )

        storage.addUser(user)
        UserDefaults.standard.set(email, forKey: loggedUserEmailKey)
        successMessage = "Votre compte a été créé avec succès"
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
    //: MARK: CHECK INPUTS

    private func isValidEmail(_ email: String) -> Bool {
        email.contains("@")
    }

    private func hasUppercase(_ password: String) -> Bool {
        password.range(of: "[A-Z]", options: .regularExpression) != nil
    }

    private func hasLowercase(_ password: String) -> Bool {
        password.range(of: "[a-z]", options: .regularExpression) != nil
    }

    private func hasDigit(_ password: String) -> Bool {
        password.range(of: "[0-9]", options: .regularExpression) != nil
    }

    private func hasSpecialCharacter(_ password: String) -> Bool {
        password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil
    }

