//
//  Favorite.swift
//  stream_app
//
//  Created by Cours on 05/02/2026.
//

import Foundation

struct Favorite: Codable, Identifiable, Hashable {
    let id: UUID
    let movie: Movie
    let userEmail: String
    let date: Date

    init(movie: Movie, userEmail: String) {
        self.id = UUID()
        self.movie = movie
        self.userEmail = userEmail
        self.date = Date()
    }
}
