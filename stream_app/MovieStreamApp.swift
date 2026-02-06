import SwiftUI

@main
struct MovieStreamApp: App {
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var themeVM = ThemeViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if authVM.isLogged {
                    MainTabView(authVM: authVM)
                } else {
                    GuestTabView(authVM: authVM)
                }
            }
            .environmentObject(themeVM)
            .preferredColorScheme(themeVM.currentTheme.colorScheme)
        }
    }
}
