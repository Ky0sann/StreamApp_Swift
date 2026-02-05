import Foundation

@MainActor
class PersonDetailViewModel: ObservableObject {
    @Published var cast: [PersonMovie] = []
    @Published var crew: [PersonMovie] = []
    
    @Published var selectedMovie: Movie?
    @Published var isLoadingMovie = false

    private let service = TMDBPeopleService()
    private let movieService = TMDBService()

    func load(person: Person) async {
        do {
            let credits = try await service.fetchCredits(for: person.id)
            cast = credits.cast
            crew = credits.crew
        } catch {
            print(error)
        }
    }
    
    func loadMovie(movieId: Int) async {
        isLoadingMovie = true
        defer { isLoadingMovie = false }

        do {
            selectedMovie = try await movieService.fetchMovie(id: movieId)
        } catch {
            print("Erreur fetch movie:", error)
        }
    }
}

