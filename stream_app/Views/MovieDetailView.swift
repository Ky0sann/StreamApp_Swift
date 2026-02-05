import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @StateObject private var favoriteVM = FavoriteViewModel()
    @StateObject private var ratingVM = RatingViewModel()
    @State private var selectedRating: Double = 0

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
                
                Text("Note des utilisateurs")
                        .font(.headline)

                    if ratingVM.average > 0 {
                        Text("⭐️ \(ratingVM.average, specifier: "%.1f") / 5 (\(ratingVM.totalRatings) avis)")
                            .foregroundColor(.secondary)
                    } else {
                        Text("Pas encore de note")
                            .foregroundColor(.secondary)
                    }

                    Divider()

                    Text("Votre note")
                        .font(.headline)

                    StarRatingView(rating: $selectedRating)

                    if selectedRating > 0 {
                        Text(RatingTitles.title(for: selectedRating))
                            .font(.caption)
                            .foregroundColor(.gray)

                        Button("Enregistrer ma note") {
                            ratingVM.rate(movie: movie, value: selectedRating)
                        }
                        .buttonStyle(.borderedProminent)
                    }

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
        .onAppear {
            ratingVM.load(movie: movie)
            selectedRating = ratingVM.userRating?.value ?? 0
        }

    }
}

