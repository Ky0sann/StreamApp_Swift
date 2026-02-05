import Foundation

@MainActor
class RatingViewModel: ObservableObject {
    @Published var userRating: Rating?
    @Published var average: Double = 0
    @Published var totalRatings: Int = 0

    private let service = RatingService()
    private let authService = AuthService()

    func load(movie: Movie) {
        guard let user = authService.getUser() else { return }

        userRating = service.ratingForUser(
            movie: movie,
            userEmail: user.email
        )

        let ratings = service.ratingsForMovie(movie: movie)
        totalRatings = ratings.count
        average = service.averageRating(movie: movie)
    }

    func rate(movie: Movie, value: Double) {
        guard let user = authService.getUser() else { return }

        service.addOrUpdateRating(
            movie: movie,
            userEmail: user.email,
            value: value
        )

        load(movie: movie)
    }
}

