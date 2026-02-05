import SwiftUI

struct MainTabView: View {
    @ObservedObject var authVM: AuthViewModel

    var body: some View {
        TabView {
            MovieListView(authVM: authVM)
                .tabItem {
                    Label("Films", systemImage: "film")
                }

            PeopleListView()
                .tabItem {
                    Label("Cast", systemImage: "person.3")
                }

            ProfileView(authVM: authVM)
                .tabItem {
                    Label("Profil", systemImage: "person.crop.circle")
                }
        }
    }
}

