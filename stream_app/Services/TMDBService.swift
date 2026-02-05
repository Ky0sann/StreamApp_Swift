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
    
    func searchMovies(query: String) async throws -> [Movie] {
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let urlString =
            "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=fr-FR&query=\(encodedQuery)"

            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }

            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(MovieResponse.self, from: data)
            return response.results
    }
    
    func fetchVideos(for movieId: Int) async throws -> [Video] {
            let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=\(apiKey)&language=fr-FR"
            guard let url = URL(string: urlString) else { throw URLError(.badURL) }

            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(MovieVideosResponse.self, from: data)
            return response.results
    }
    
    func fetchMovie(id: Int) async throws -> Movie {
        let urlString =
        "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)&language=fr-FR"

        let url = URL(string: urlString)!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Movie.self, from: data)
    }
    
    func fetchMovieCredits(movieId: Int) async throws -> MovieCredits {
        let urlString =
        "https://api.themoviedb.org/3/movie/\(movieId)/credits?api_key=\(apiKey)&language=fr-FR"

        let url = URL(string: urlString)!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(MovieCredits.self, from: data)
    }

}
