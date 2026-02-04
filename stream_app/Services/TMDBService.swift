// Services/TMDBService.swift
import Foundation

class TMDBService {
    private let apiKey = "249d2b320affa332d2bc9bf22ee550de"
    
    func fetchPopularMovies() async throws -> [Movie] {
        let urlString =
        "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=fr-FR"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MovieResponse.self, from: data)
        return response.results
    }
}

