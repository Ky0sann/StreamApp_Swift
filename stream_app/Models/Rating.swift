import Foundation

struct Rating: Codable, Identifiable {
    let id: UUID
    let movie: Movie
    let userEmail: String
    let value: Double
    let title: String
    let date: Date

    init(movie: Movie, userEmail: String, value: Double, title: String) {
        self.id = UUID()
        self.movie = movie
        self.userEmail = userEmail
        self.value = value
        self.title = title
        self.date = Date()
    }
}

