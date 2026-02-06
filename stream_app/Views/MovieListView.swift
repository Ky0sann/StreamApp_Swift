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
            .searchable(text: $movieVM.searchText, prompt: "Rechercher un film")
            .accessibilityIdentifier("movie_search")
            .onChange(of: movieVM.searchText) { _, newValue in
                Task {
                    try await Task.sleep(nanoseconds: 300_000_000)
                    if newValue == movieVM.searchText {
                        if movieVM.searchText.count >= 4 || movieVM.searchText.isEmpty {
                            await movieVM.search()
                        }
                    }
                }
            }
            .submitLabel(.search)
            .onSubmit(of: .search) {
                Task {
                    await movieVM.search()
                }
            }
            .task {
                await movieVM.loadMovies()
            }
        }
    }
}

