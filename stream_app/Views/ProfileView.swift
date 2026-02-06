import SwiftUI

struct ProfileView: View {
    @ObservedObject var authVM: AuthViewModel
    @StateObject private var favoriteVM = FavoriteViewModel()
    @StateObject private var userVM = UserViewModel()
    @EnvironmentObject var themeVM: ThemeViewModel

    @State private var editing = false
    @State private var newUsername = ""
    @State private var newBio = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @StateObject private var userRatingsVM = UserRatingsViewModel()

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
                
                Section("Mes dernières notes") {
                    if userRatingsVM.ratings.isEmpty {
                        Text("Vous n'avez pas encore noté de film")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(userRatingsVM.ratings.prefix(10)) { rating in
                            NavigationLink(
                                destination: MovieDetailView(movie: rating.movie)
                            ) {
                                HStack(spacing: 12) {

                                    if let url = rating.movie.posterURL {
                                        AsyncImage(url: url) { image in
                                            image.resizable()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 40, height: 60)
                                        .cornerRadius(6)
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(rating.movie.title)
                                            .bold()

                                        HStack {
                                            ReadOnlyStarRatingView(rating: rating.value)
                                            Text(rating.title)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                            }
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
                
                Section("Apparence") {
                    Picker("Thème", selection: $themeVM.currentTheme) {
                        ForEach(AppTheme.allCases) { theme in
                            Label(theme.title, systemImage: theme.icon)
                                .tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Cache") {
                    Button("Nettoyer le cache") {
                        alertMessage = ClearCacheService.clearCache()
                        showAlert = true
                    }
                    .foregroundColor(.red)
                }
                .alert("Cache", isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(alertMessage)
                }
 
                Section("Développeurs") {
                    Link(destination: URL(string: "https://github.com/Ky0sann/StreamApp_Swift")!) {
                        Label("Voir sur GitHub", systemImage: "link")
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
                userRatingsVM.load()
            }
        }
    }
}

