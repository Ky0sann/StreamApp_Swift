import Foundation

@MainActor
class FavoriteViewModel: ObservableObject {
    @Published private(set) var favorites: [Movie] = []

    private let service = FavoriteService()

    init() {
        loadFavorites()
    }

    func loadFavorites() {
        favorites = service.getFavorites()
    }

    func toggleFavorite(movie: Movie) {
        if service.isFavorite(movie: movie) {
            service.removeFromFavorites(movie: movie)
        } else {
            service.addToFavorites(movie: movie)
        }
        loadFavorites()
    }

    func isFavorite(movie: Movie) -> Bool {
        service.isFavorite(movie: movie)
    }
}

