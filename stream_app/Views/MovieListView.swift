// Views/MovieListView.swift
import SwiftUI

struct MovieListView: View {
    @StateObject private var movieVM = MovieViewModel()
    @ObservedObject var authVM: AuthViewModel

    var body: some View {
        NavigationStack {
            List(movieVM.movies) { movie in
                NavigationLink(destination: MovieDetailView(movie: movie)) {
                    HStack {
                        if let url = movie.posterURL {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 60, height: 90)
                            .cornerRadius(8)
                        }

                        VStack(alignment: .leading) {
                            Text(movie.title).bold()
                            Text(movie.overview)
                                .lineLimit(3)
                                .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("Films populaires")
            .toolbar {
                Button("Logout") {
                    authVM.logout()
                }
            }
            .task {
                await movieVM.loadMovies()
            }
        }
    }
}

