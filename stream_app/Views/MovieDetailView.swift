// Views/MovieDetailView.swift
import SwiftUI

struct MovieDetailView: View {
    let movie: Movie

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let url = movie.posterURL {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
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

                // Ici on pourrait ajouter plus de détails (date, note, genres)
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

