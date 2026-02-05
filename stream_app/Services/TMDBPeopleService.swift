import Foundation

class TMDBPeopleService {
    private let apiKey = "249d2b320affa332d2bc9bf22ee550de"

    func fetchPopularPeople() async throws -> [Person] {
        let urlString =
        "https://api.themoviedb.org/3/person/popular?api_key=\(apiKey)&language=fr-FR"

        let url = URL(string: urlString)!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PersonResponse.self, from: data).results
    }

    func searchPeople(query: String) async throws -> [Person] {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString =
        "https://api.themoviedb.org/3/search/person?api_key=\(apiKey)&language=fr-FR&query=\(encoded)"

        let url = URL(string: urlString)!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PersonResponse.self, from: data).results
    }

    func fetchCredits(for personId: Int) async throws -> PersonCredits {
        let urlString =
        "https://api.themoviedb.org/3/person/\(personId)/combined_credits?api_key=\(apiKey)&language=fr-FR"

        let url = URL(string: urlString)!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PersonCredits.self, from: data)
    }
}

