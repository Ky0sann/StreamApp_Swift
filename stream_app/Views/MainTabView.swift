import SwiftUI

struct MainTabView: View {
    @ObservedObject var authVM: AuthViewModel

    var body: some View {
        TabView {
            MovieListView(authVM: authVM)
                .tabItem {
                    Label("Films", systemImage: "film")
                }.accessibilityIdentifier("tab_films")

            PeopleListView()
                .tabItem {
                    Label("Cast", systemImage: "person.3")
                }.accessibilityIdentifier("tab_cast")

            ProfileView(authVM: authVM)
                .tabItem {
                    Label("Profil", systemImage: "person.crop.circle")
                }.accessibilityIdentifier("tab_profil")
        }
    }
}

