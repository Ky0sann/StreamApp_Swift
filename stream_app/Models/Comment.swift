import Foundation

struct Comment: Codable, Identifiable {
    let id: UUID
    let movieId: Int
    let userEmail: String
    let username: String
    let text: String
    let date: Date

    init(movieId: Int,
         userEmail: String,
         username: String,
         text: String) {
        self.id = UUID()
        self.movieId = movieId
        self.userEmail = userEmail
        self.username = username
        self.text = text
        self.date = Date()
    }
}
