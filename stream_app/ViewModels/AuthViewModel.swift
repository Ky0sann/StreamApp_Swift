import Foundation

class AuthViewModel: ObservableObject {
    @Published var isLogged: Bool = false
    
    @Published var errorMessageLogin: String? 
    @Published var successMessage: String?

    private let authService = AuthService()

    init() {
        isLogged = authService.isLogged()
    }

    func login(email: String, password: String) {
        let success = authService.login(email: email, password: password)

        if success {
            errorMessageLogin = nil
            successMessage = authService.successMessage
            
            // Délai avant navigation
                   DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                       self.isLogged = true
                       self.successMessage = nil
                   }
        } else {
            isLogged = false
            successMessage = nil
            errorMessageLogin = authService.errorMessageLogin
            
        }
    }

    func register(username:String,email: String, password: String) {
        let success = authService.register(username: username, email: email, password: password)

        if success {
            errorMessageLogin = nil
            successMessage = authService.successMessage
    
            // Délai avant navigation
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
               self.isLogged = true
               self.successMessage = nil
           }
        }  else {
            isLogged = false
            errorMessageLogin = authService.errorMessageLogin
        }
    }

    func logout() {
        authService.logout()
        isLogged = false
    }
}

