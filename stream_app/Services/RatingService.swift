import Foundation

class RatingService {
    private let ratingsKey = "MOVIE_RATINGS"

    private func getAllRatings() -> [Rating] {
        guard let data = UserDefaults.standard.data(forKey: ratingsKey) else {
            return []
        }
        return (try? JSONDecoder().decode([Rating].self, from: data)) ?? []
    }

    private func saveAll(_ ratings: [Rating]) {
        if let data = try? JSONEncoder().encode(ratings) {
            UserDefaults.standard.set(data, forKey: ratingsKey)
        }
    }

    func addOrUpdateRating(movie: Movie, userEmail: String, value: Double) {
        var ratings = getAllRatings()

        ratings.removeAll {
            $0.movie.id == movie.id && $0.userEmail == userEmail
        }

        let title = RatingTitles.title(for: value)
        let rating = Rating(movie: movie,
                            userEmail: userEmail,
                            value: value,
                            title: title)

        ratings.append(rating)
        saveAll(ratings)
    }

    func ratingForUser(movie: Movie, userEmail: String) -> Rating? {
        getAllRatings().first {
            $0.movie.id == movie.id && $0.userEmail == userEmail
        }
    }

    func ratingsForMovie(movie: Movie) -> [Rating] {
        getAllRatings().filter { $0.movie.id == movie.id }
    }

    func averageRating(movie: Movie) -> Double {
        let ratings = ratingsForMovie(movie: movie)
        guard !ratings.isEmpty else { return 0 }
        let total = ratings.map { $0.value }.reduce(0, +)
        return total / Double(ratings.count)
    }
    
    func ratingsForUser(userEmail: String) -> [Rating] {
        getAllRatings()
            .filter { $0.userEmail == userEmail }
            .sorted { $0.date > $1.date }
    }
}

