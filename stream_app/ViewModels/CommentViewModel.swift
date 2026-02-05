import Foundation

@MainActor
class CommentViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var newCommentText: String = ""

    private let service = CommentService()
    private let authService = AuthService()
    private let ratingService = RatingService()

    func load(movie: Movie) {
        comments = service.comments(for: movie.id)
    }

    func addComment(movie: Movie, rating: Double?) {
        guard
            let user = authService.getUser(),
            !newCommentText.trimmingCharacters(in: .whitespaces).isEmpty
        else { return }

        let comment = Comment(
            movieId: movie.id,
            userEmail: user.email,
            username: user.username,
            text: newCommentText
        )

        service.add(comment: comment)
        newCommentText = ""
        load(movie: movie)
    }
    
    func rating(for comment: Comment) -> Double? {
        ratingService
            .ratingForUser(
                movie: Movie(
                    id: comment.movieId,
                    title: "",
                    overview: "",
                    poster_path: nil
                ),
                userEmail: comment.userEmail
            )?
            .value
    }
    
    func deleteComment(_ comment: Comment, movie: Movie) {
        guard let user = authService.getUser(),
              comment.userEmail == user.email else { return }

        service.delete(comment: comment)
        load(movie: movie)
    }

}

