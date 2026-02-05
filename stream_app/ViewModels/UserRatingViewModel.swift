import Foundation

@MainActor
class UserRatingsViewModel: ObservableObject {
    @Published var ratings: [Rating] = []

    private let ratingService = RatingService()
    private let authService = AuthService()

    func load() {
        guard let user = authService.getUser() else { return }
        ratings = ratingService.ratingsForUser(userEmail: user.email)
    }
}

