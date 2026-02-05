import SwiftUI

struct PersonDetailView: View {
    let person: Person
    @StateObject private var vm = PersonDetailViewModel()
    @State private var showMovieDetail = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                if let url = person.profileURL {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .cornerRadius(12)
                }

                Text(person.name)
                    .font(.title)
                    .bold()

                if !vm.cast.isEmpty {
                    Text("🎭 Films (acteur)")
                        .font(.headline)

                    ForEach(vm.cast) { movie in
                        Button {
                            Task {
                                await vm.loadMovie(movieId: movie.id)
                                showMovieDetail = true
                            }
                        } label: {
                            HStack {
                                if let url = movie.posterURL {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                    } placeholder: {
                                        Color.gray.opacity(0.3)
                                    }
                                    .frame(width: 40, height: 60)
                                    .cornerRadius(6)
                                }

                                VStack(alignment: .leading) {
                                    Text(movie.title ?? "—")
                                        .foregroundColor(.primary)

                                    if let character = movie.character {
                                        Text("Rôle : \(character)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }

                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }

                }

                if !vm.crew.isEmpty {
                    Text("🎬 Réalisations / équipe")
                        .font(.headline)

                    ForEach(vm.crew) { movie in
                        Button {
                            Task {
                                await vm.loadMovie(movieId: movie.id)
                                showMovieDetail = true
                            }
                        } label: {
                            HStack {
                                if let url = movie.posterURL {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                    } placeholder: {
                                        Color.gray.opacity(0.3)
                                    }
                                    .frame(width: 40, height: 60)
                                    .cornerRadius(6)
                                }

                                VStack(alignment: .leading) {
                                    Text(movie.title ?? "—")
                                        .foregroundColor(.primary)

                                    if let job = movie.job {
                                        Text("Job : \(job)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }

                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }

                }
            }
            .padding()
        }
        .navigationTitle(person.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showMovieDetail) {
            if let movie = vm.selectedMovie {
                MovieDetailView(movie: movie)
            }
        }
        .overlay {
            if vm.isLoadingMovie {
                ZStack {
                    Color.black.opacity(0.2)
                    ProgressView("Chargement du film…")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
            }
        }
        .task {
            await vm.load(person: person)
        }
    }
}

