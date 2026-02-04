import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @StateObject private var favoriteVM = FavoriteViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let url = movie.posterURL {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                    } placeholder: {
                        ProgressView()
                    }
                }

                Text(movie.title)
                    .font(.title)
                    .bold()

                Text(movie.overview)
                    .font(.body)

                Button(action: {
                    favoriteVM.toggleFavorite(movie: movie)
                }) {
                    HStack {
                        Image(systemName: favoriteVM.isFavorite(movie: movie) ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                        Text(favoriteVM.isFavorite(movie: movie) ? "Retirer des favoris" : "Ajouter aux favoris")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

