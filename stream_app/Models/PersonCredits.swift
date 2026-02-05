import Foundation

struct PersonCredits: Codable {
    let cast: [PersonMovie]
    let crew: [PersonMovie]
}

struct PersonMovie: Codable, Identifiable {
    let id: Int
    let title: String?
    let job: String?
    let character: String?
    let poster_path: String?

    var posterURL: URL? {
        guard let poster_path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w300\(poster_path)")
    }
}

