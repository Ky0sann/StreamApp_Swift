import Foundation

@MainActor
class MovieCastViewModel: ObservableObject {
    @Published var cast: [MovieCastPerson] = []
    @Published var directors: [MovieCastPerson] = []

    private let service = TMDBService()

    func load(movie: Movie) async {
        do {
            let credits = try await service.fetchMovieCredits(movieId: movie.id)
            cast = credits.cast
            directors = credits.crew.filter { $0.job == "Director" }
        } catch {
            print("Erreur cast:", error)
        }
    }
}

