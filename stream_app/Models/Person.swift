import Foundation

struct PersonResponse: Codable {
    let results: [Person]
}

struct Person: Codable, Identifiable {
    let id: Int
    let name: String
    let profile_path: String?
    let known_for_department: String?

    var profileURL: URL? {
        guard let profile_path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w300\(profile_path)")
    }
}
