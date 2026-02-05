import Foundation

class FavoriteService {

    private let favoritesKey = "FAVORITE_MOVIES"
    private let authService = AuthService()

    // MARK: - Private

    private func getAllFavorites() -> [Favorite] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let favorites = try? JSONDecoder().decode([Favorite].self, from: data) else {
            return []
        }
        return favorites
    }

    private func save(all favorites: [Favorite]) {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }

    private var currentUserEmail: String? {
        authService.getUser()?.email
    }

    // MARK: - Public API (INCHANGÉE)

    func getFavorites() -> [Movie] {
        guard let email = currentUserEmail else { return [] }

        return getAllFavorites()
            .filter { $0.userEmail == email }
            .map { $0.movie }
    }

    func addToFavorites(movie: Movie) {
        guard let email = currentUserEmail else { return }

        var allFavorites = getAllFavorites()

        let alreadyExists = allFavorites.contains {
            $0.movie.id == movie.id && $0.userEmail == email
        }

        guard !alreadyExists else { return }

        let favorite = Favorite(movie: movie, userEmail: email)
        allFavorites.append(favorite)
        save(all: allFavorites)
    }

    func removeFromFavorites(movie: Movie) {
        guard let email = currentUserEmail else { return }

        var allFavorites = getAllFavorites()
        allFavorites.removeAll {
            $0.movie.id == movie.id && $0.userEmail == email
        }
        save(all: allFavorites)
    }

    func isFavorite(movie: Movie) -> Bool {
        guard let email = currentUserEmail else { return false }

        return getAllFavorites().contains {
            $0.movie.id == movie.id && $0.userEmail == email
        }
    }
}

