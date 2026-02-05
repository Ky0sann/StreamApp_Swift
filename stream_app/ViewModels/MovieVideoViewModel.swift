import Foundation

@MainActor
class MovieVideoViewModel: ObservableObject {
    @Published var videos: [Video] = []

    private let service = TMDBService()

    func loadVideos(for movieId: Int) async {
        do {
            videos = try await service.fetchVideos(for: movieId)
        } catch {
            print("Erreur fetch videos:", error)
        }
    }
    
    var trailerURL: URL? {
        guard let trailer = videos.first(where: { $0.type.lowercased() == "trailer" && $0.site.lowercased() == "youtube" }) else {
            return nil
        }
        return URL(string: "https://www.youtube.com/watch?v=\(trailer.key)")
    }
}
