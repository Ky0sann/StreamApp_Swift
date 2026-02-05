import Foundation

struct MovieCredits: Codable {
    let cast: [MovieCastPerson]
    let crew: [MovieCastPerson]
}

struct MovieCastPerson: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String?
    let job: String?
    let profile_path: String?

    var profileURL: URL? {
        guard let profile_path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(profile_path)")
    }
}

