import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @StateObject private var favoriteVM = FavoriteViewModel()
    @StateObject private var ratingVM = RatingViewModel()
    @StateObject private var videoVM = MovieVideoViewModel()
    private let authService = AuthService()
    
    @State private var selectedRating: Double = 0
    @State private var showingTrailer = false
    
    @StateObject private var commentVM = CommentViewModel()
    
    @StateObject private var castVM = MovieCastViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let url = movie.posterURL {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                    } placeholder: {
                        ProgressView()
                    }
                }

                Text(movie.title)
                    .font(.title)
                    .bold()

                Text(movie.overview)
                    .font(.body)
                
                if !castVM.directors.isEmpty {
                    Text("🎬 Réalisateur(s)")
                        .font(.headline)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(castVM.directors) { person in
                                NavigationLink(destination: PersonDetailView(
                                    person: Person(
                                        id: person.id,
                                        name: person.name,
                                        profile_path: person.profile_path,
                                        known_for_department: "Directing"
                                    )
                                )) {
                                    VStack {
                                        if let url = person.profileURL {
                                            AsyncImage(url: url) { image in
                                                image.resizable()
                                            } placeholder: {
                                                Color.gray.opacity(0.3)
                                            }
                                            .frame(width: 80, height: 120)
                                            .cornerRadius(8)
                                        }

                                        Text(person.name)
                                            .font(.caption)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(width: 90)
                                }
                            }
                        }
                    }
                }

                Text("🎭 Casting")
                    .font(.headline)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(castVM.cast.prefix(20)) { person in
                            NavigationLink(destination: PersonDetailView(
                                person: Person(
                                    id: person.id,
                                    name: person.name,
                                    profile_path: person.profile_path,
                                    known_for_department: "Acting"
                                )
                            )) {
                                VStack {
                                    if let url = person.profileURL {
                                        AsyncImage(url: url) { image in
                                            image.resizable()
                                        } placeholder: {
                                            Color.gray.opacity(0.3)
                                        }
                                        .frame(width: 80, height: 120)
                                        .cornerRadius(8)
                                    }

                                    Text(person.name)
                                        .font(.caption)
                                        .multilineTextAlignment(.center)

                                    if let character = person.character {
                                        Text(character)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .frame(width: 90)
                            }
                        }
                    }
                }

                if let _ = videoVM.trailerURL {
                    Button("Voir la bande annonce") {
                        showingTrailer = true
                    }
                    .accessibilityIdentifier("trailer_button")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }

                Text("Note des utilisateurs")
                        .font(.headline)

                    if ratingVM.average > 0 {
                        Text("⭐️ \(ratingVM.average, specifier: "%.1f") / 5 (\(ratingVM.totalRatings) avis)")
                            .foregroundColor(.secondary)
                    } else {
                        Text("Pas encore de note")
                            .foregroundColor(.secondary)
                    }

                    Divider()

                    Text("Votre note")
                        .font(.headline)

                    StarRatingView(rating: $selectedRating)

                    if selectedRating > 0 {
                        Text(RatingTitles.title(for: selectedRating))
                            .font(.caption)
                            .foregroundColor(.gray)

                        Button("Enregistrer ma note") {
                            ratingVM.rate(movie: movie, value: selectedRating)
                            commentVM.load(movie: movie)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                
                Divider()

                Text("Commentaires")
                    .font(.headline)

                TextField("Ajouter un commentaire…", text: $commentVM.newCommentText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)

                Button("Publier") {
                    commentVM.addComment(
                        movie: movie,
                        rating: selectedRating > 0 ? selectedRating : nil
                    )
                }
                .accessibilityIdentifier("publish_comment")
                .buttonStyle(.bordered)
                .disabled(commentVM.newCommentText.trimmingCharacters(in: .whitespaces).isEmpty)
                
                if commentVM.comments.isEmpty {
                    Text("Aucun commentaire pour le moment")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(commentVM.comments) { comment in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(comment.username)
                                    .bold()
                                
                                if comment.userEmail == AuthService().getUser()?.email {
                                    Text("Vous")
                                        .font(.caption2)
                                        .padding(4)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(4)
                                }
                                
                                if comment.userEmail == authService.getUser()?.email {
                                    Button("Supprimer") {
                                        commentVM.deleteComment(comment, movie: movie)
                                    }
                                    .font(.caption)
                                    .foregroundColor(.red)
                                }

                                Spacer()

                                if let rating = commentVM.rating(for: comment) {
                                    ReadOnlyStarRatingView(rating: rating)
                                }
                            }

                            Text(comment.text)

                            Text(comment.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 6)

                        Divider()
                    }
                }


                Button(action: {
                    favoriteVM.toggleFavorite(movie: movie)
                }) {
                    HStack {
                        Image(systemName: favoriteVM.isFavorite(movie: movie) ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                        Text(favoriteVM.isFavorite(movie: movie) ? "Retirer des favoris" : "Ajouter aux favoris")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }.accessibilityIdentifier("favorite_button")
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            ratingVM.load(movie: movie)
            selectedRating = ratingVM.userRating?.value ?? 0
            commentVM.load(movie: movie)

            Task {
                await videoVM.loadVideos(for: movie.id)
                await castVM.load(movie: movie)
            }
        }
        .sheet(isPresented: $showingTrailer) {
            if let url = videoVM.trailerURL {
                TrailerView(url: url)
                    .ignoresSafeArea()
            }
        }
    }
}
