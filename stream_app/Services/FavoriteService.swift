import Foundation

class FavoriteService {
    private let favoritesKey = "FAVORITE_MOVIES"

    func getFavorites() -> [Movie] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey) else { return [] }
        return (try? JSONDecoder().decode([Movie].self, from: data)) ?? []
    }

    func addToFavorites(movie: Movie) {
        var current = getFavorites()
        if !current.contains(movie) {
            current.append(movie)
        }
        save(favorites: current)
    }

    func removeFromFavorites(movie: Movie) {
        var current = getFavorites()
        current.removeAll { $0.id == movie.id }
        save(favorites: current)
    }

    private func save(favorites: [Movie]) {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }

    func isFavorite(movie: Movie) -> Bool {
        getFavorites().contains(movie)
    }
}

