import Foundation

@MainActor
class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var searchText: String = ""

    private let service = TMDBService()

    func loadMovies() async {
        do {
            movies = try await service.fetchPopularMovies()
        } catch {
            print("Erreur TMDB:", error)
        }
    }

    func search() async {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            await loadMovies()
            return
        }

        do {
            movies = try await service.searchMovies(query: searchText)
        } catch {
            print("Erreur recherche:", error)
        }
    }
}

