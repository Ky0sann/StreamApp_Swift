import SwiftUI

@main
struct MovieStreamApp: App {
    @StateObject private var authVM = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            if authVM.isLogged {
                MainTabView(authVM: authVM)
            } else {
                            NavigationStack {
                    LoginView(authVM: authVM)
                }
            }
        }
    }
}

