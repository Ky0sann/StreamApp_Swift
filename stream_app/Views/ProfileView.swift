import SwiftUI

struct ProfileView: View {
    @ObservedObject var authVM: AuthViewModel
    @StateObject private var favoriteVM = FavoriteViewModel()
    @StateObject private var userVM = UserViewModel()

    @State private var editing = false
    @State private var newUsername = ""
    @State private var newBio = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Infos utilisateur") {
                    if editing {
                        TextField("Nom d'utilisateur", text: $newUsername)
                        TextField("Bio", text: $newBio)
                        Button("Enregistrer") {
                            userVM.updateUser(username: newUsername, bio: newBio)
                            editing = false
                        }
                        .foregroundColor(.blue)
                    } else {
                        Text("Email : \(userVM.user.email)")
                        Text("Nom : \(userVM.user.username)")
                        if let bio = userVM.user.bio, !bio.isEmpty {
                            Text("Bio : \(bio)")
                        }
                        Button("Modifier") {
                            newUsername = userVM.user.username
                            newBio = userVM.user.bio ?? ""
                            editing = true
                        }
                    }
                }

                Section("Favoris") {
                    if favoriteVM.favorites.isEmpty {
                        Text("Aucun favori pour le moment")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(favoriteVM.favorites) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                HStack {
                                    if let url = movie.posterURL {
                                        AsyncImage(url: url) { image in
                                            image.resizable()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 50, height: 75)
                                        .cornerRadius(6)
                                    }
                                    Text(movie.title)
                                }
                            }
                        }
                    }
                }

                Section {
                    Button("Se déconnecter") {
                        authVM.logout()
                    }
                    .foregroundColor(.red)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Profil")
            .onAppear {
                favoriteVM.loadFavorites()
            }
        }
    }
}

