import Foundation

class CommentService {
    private let commentsKey = "MOVIE_COMMENTS"

    private func loadAll() -> [Comment] {
        guard let data = UserDefaults.standard.data(forKey: commentsKey) else {
            return []
        }
        return (try? JSONDecoder().decode([Comment].self, from: data)) ?? []
    }

    private func saveAll(_ comments: [Comment]) {
        if let data = try? JSONEncoder().encode(comments) {
            UserDefaults.standard.set(data, forKey: commentsKey)
        }
    }

    func add(comment: Comment) {
        var comments = loadAll()
        comments.append(comment)
        saveAll(comments)
    }

    func comments(for movieId: Int) -> [Comment] {
        loadAll()
            .filter { $0.movieId == movieId }
            .sorted { $0.date > $1.date }
    }
    
    func delete(comment: Comment) {
        var comments = loadAll()
        comments.removeAll { $0.id == comment.id }
        saveAll(comments)
    }
}

