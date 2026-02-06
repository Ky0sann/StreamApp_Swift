//
//  GuestMovieListView.swift
//  stream_app
//
//  Created by Cours on 05/02/2026.
//
 
import SwiftUI
 
struct GuestMovieListView: View {
    @StateObject private var movieVM = MovieViewModel()
    @ObservedObject var authVM: AuthViewModel
 
    var body: some View {
        NavigationStack {
            List {
                // Header avec boutons
                Section {
                    HStack {
                        Spacer()

                        NavigationLink(destination: LoginView(authVM: authVM)) {
                            Text("Se connecter")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.blue)
                                        .shadow(color: Color.blue.opacity(0.3), radius: 6, x: 0, y: 4)
                                )
                        }
                        .buttonStyle(.plain)

                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                .listRowSeparator(.hidden)
 
                // Liste des films
                ForEach(movieVM.movies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        HStack {
                            if let url = movie.posterURL {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 60, height: 90)
                                .cornerRadius(8)
                            }
 
                            VStack(alignment: .leading) {
                                Text(movie.title).bold()
                                Text(movie.overview)
                                    .lineLimit(3)
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Films")
            .searchable(text: $movieVM.searchText, prompt: "Rechercher un film")
            .onChange(of: movieVM.searchText) { _, newValue in
                Task {
                    try await Task.sleep(nanoseconds: 300_000_000)
                    if newValue == movieVM.searchText {
                        if movieVM.searchText.count >= 4 || movieVM.searchText.isEmpty {
                            await movieVM.search()
                        }
                    }
                }
            }
            .submitLabel(.search)
            .onSubmit(of: .search) {
                Task {
                    await movieVM.search()
                }
            }
            .task {
                await movieVM.loadMovies()
            }
        }
    }
}
