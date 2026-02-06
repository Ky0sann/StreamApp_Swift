//
//  stream_appTests.swift
//  stream_appTests
//
//  Created by Cours on 06/02/2026.
//

import Testing
import Foundation

@testable import stream_app

struct stream_appTests {

    // MARK: - Helpers

    private func clearAllUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "LOGGED_USER_EMAIL")
        defaults.removeObject(forKey: "MOVIE_COMMENTS")
        defaults.removeObject(forKey: "FAVORITE_MOVIES")
        defaults.removeObject(forKey: "MOVIE_RATINGS")
        defaults.synchronize()
    }

    private func randomEmail() -> String {
        return "test\(UUID().uuidString.prefix(8))@mail.com"
    }

    // MARK: - AuthService Tests

    @Test func testLoginEmptyFieldsFails() {
        clearAllUserDefaults()
        let auth = AuthService()

        let result = auth.login(email: "", password: "")
        #expect(result == false)
        #expect(auth.errorMessageLogin == "Veillez remplir tous les champs")
    }

    @Test func testLoginInvalidEmailFails() {
        clearAllUserDefaults()
        let auth = AuthService()

        let result = auth.login(email: "testmail.com", password: "Abc123!")
        #expect(result == false)
        #expect(auth.errorMessageLogin == "L’adresse email doit contenir @.")
    }

    @Test func testRegisterValidUserSuccess() {
        clearAllUserDefaults()
        let auth = AuthService()

        let email = randomEmail()
        let result = auth.register(username: "test", email: email, password: "Abc123!")
        #expect(result == true)
        #expect(auth.successMessage == "Votre compte a été créé avec succès")
        #expect(auth.isLogged() == true)
    }

    @Test func testRegisterDuplicateEmailFails() {
        clearAllUserDefaults()
        let auth = AuthService()

        let email = randomEmail()
        _ = auth.register(username: "test", email: email, password: "Abc123!")
        let result2 = auth.register(username: "test", email: email, password: "Abc123!")

        #expect(result2 == false)
        #expect(auth.errorMessageLogin == "Cette adresse mail est déjà utilisée.")
    }

    @Test func testLogoutClearsSession() {
        clearAllUserDefaults()
        let auth = AuthService()

        let email = randomEmail()
        _ = auth.register(username: "Test", email: email, password: "Abc123!")
        auth.logout()

        #expect(auth.isLogged() == false)
    }

    // MARK: - UserStorageService Tests

    @Test func testUserStorageSaveAndLoad() {
        let storage = UserStorageService()

        // Clear file by saving empty list
        storage.saveUsers([])

        let user = User(email: "user@mail.com", username: "user", password: "hashed")
        storage.saveUsers([user])

        let loaded = storage.loadUsers()
        #expect(loaded.count == 1)
        #expect(loaded.first?.email == "user@mail.com")
    }

    @Test func testUserExists() {
        let storage = UserStorageService()
        storage.saveUsers([])

        let user = User(email: "exist@mail.com", username: "exist", password: "hashed")
        storage.saveUsers([user])

        #expect(storage.userExists(email: "exist@mail.com") == true)
        #expect(storage.userExists(email: "not@mail.com") == false)
    }

    @Test func testValidateCredentials() {
        let storage = UserStorageService()
        storage.saveUsers([])

        let password = "Abc123!"
        let hashed = password.sha256()

        let user = User(email: "valid@mail.com", username: "valid", password: hashed)
        storage.saveUsers([user])

        #expect(storage.validateCredentials(email: "valid@mail.com", password: password) == true)
    }

    // MARK: - ClearCacheService Tests

    @Test func testClearCacheReturnsMessage() {
        let message = ClearCacheService.clearCache()
        #expect(message.contains("Cache vidé :"))
    }

    // MARK: - CommentService Tests

    @Test func testAddAndFetchComments() {
        clearAllUserDefaults()
        let service = CommentService()

        let comment1 = Comment(movieId: 1,
                               userEmail: "u1@mail.com",
                               username: "User1",
                               text: "Test 1")

        Thread.sleep(forTimeInterval: 0.1)

        let comment2 = Comment(movieId: 1,
                               userEmail: "u2@mail.com",
                               username: "User2",
                               text: "Test 2")

        service.add(comment: comment1)
        service.add(comment: comment2)

        let comments = service.comments(for: 1)

        #expect(comments.count == 2)
        #expect(comments.first?.text == "Test 2")
        #expect(comments.first?.username == "User2")
    }

    @Test func testDeleteComment() {
        clearAllUserDefaults()
        let service = CommentService()

        let comment = Comment(movieId: 1,
                              userEmail: "u1@mail.com",
                              username: "User1",
                              text: "To delete")

        service.add(comment: comment)
        service.delete(comment: comment)

        let comments = service.comments(for: 1)
        #expect(comments.isEmpty)
    }

    // MARK: - RatingService Tests

    @Test func testAddOrUpdateRating() {
        clearAllUserDefaults()
        let service = RatingService()

        let movie = Movie(id: 1, title: "Test", overview: "", poster_path: nil)
        service.addOrUpdateRating(movie: movie, userEmail: "test@mail.com", value: 4.0)

        let rating = service.ratingForUser(movie: movie, userEmail: "test@mail.com")
        #expect(rating != nil)
        #expect(rating?.value == 4.0)
        #expect(rating?.title.isEmpty == false)
        #expect(rating?.date.timeIntervalSinceNow ?? 0 <= 0)
    }

    @Test func testAverageRating() {
        clearAllUserDefaults()
        let service = RatingService()

        let movie = Movie(id: 2, title: "Test2", overview: "", poster_path: nil)
        service.addOrUpdateRating(movie: movie, userEmail: "a@mail.com", value: 3.0)
        service.addOrUpdateRating(movie: movie, userEmail: "b@mail.com", value: 5.0)

        let avg = service.averageRating(movie: movie)
        #expect(avg >= 0.0)
    }

    // MARK: - FavoriteService Tests

    @Test func testAddRemoveFavorite() {
        clearAllUserDefaults()

        let auth = AuthService()
        let email = randomEmail()
        _ = auth.register(username: "UserFav", email: email, password: "Abc123!")
        _ = auth.login(email: email, password: "Abc123!")

        let favoriteService = FavoriteService()
        let movie = Movie(id: 1, title: "Favorite", overview: "", poster_path: nil)

        favoriteService.addToFavorites(movie: movie)
        #expect(favoriteService.isFavorite(movie: movie) == true)

        favoriteService.removeFromFavorites(movie: movie)
        #expect(favoriteService.isFavorite(movie: movie) == false)
    }

    @Test func testGetFavoritesReturnsOnlyUserMovies() {
        clearAllUserDefaults()

        let auth = AuthService()
        let email1 = randomEmail()
        _ = auth.register(username: "User1", email: email1, password: "Abc123!")
        _ = auth.login(email: email1, password: "Abc123!")

        let favService = FavoriteService()
        let movie = Movie(id: 1, title: "Fav1", overview: "", poster_path: nil)
        favService.addToFavorites(movie: movie)

        auth.logout()

        let email2 = randomEmail()
        _ = auth.register(username: "User2", email: email2, password: "Abc123!")

        let movies = favService.getFavorites()
        #expect(movies.isEmpty)
    }
}
