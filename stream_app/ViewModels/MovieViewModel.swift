// ViewModels/MovieViewModel.swift
import Foundation

@MainActor
class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    
    private let service = TMDBService()

    func loadMovies() async {
        do {
            movies = try await service.fetchPopularMovies()
        } catch {
            print("Erreur TMDB:", error)
        }
    }
}

