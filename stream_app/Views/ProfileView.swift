import SwiftUI

struct ProfileView: View {
    @ObservedObject var authVM: AuthViewModel
    @StateObject private var favoriteVM = FavoriteViewModel()

    var body: some View {
        NavigationStack {
            List {
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

