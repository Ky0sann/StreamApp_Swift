//
//  UserStorageService.swift
//  stream_app
//
//  Created by Cours on 05/02/2026.
//

import Foundation

class UserStorageService {

    // MARK: File URL
    private var usersFileURL: URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("users.json")
    }

    // MARK: Load
    func loadUsers() -> [User] {
        guard FileManager.default.fileExists(atPath: usersFileURL.path),
              let data = try? Data(contentsOf: usersFileURL) else {
            return []
        }

        return (try? JSONDecoder().decode([User].self, from: data)) ?? []
    }

    // MARK: Save
    func saveUsers(_ users: [User]) {
        guard let data = try? JSONEncoder().encode(users) else { return }
        try? data.write(to: usersFileURL, options: .atomic)
    }

    // MARK: Add (no duplicates)
    func addUser(_ user: User) {
        var users = loadUsers()

        // Empêche les doublons sur l’email
        guard !users.contains(where: { $0.email.lowercased() == user.email.lowercased() }) else {
            return
        }

        users.append(user)
        saveUsers(users)
    }

    // MARK: Exists
    func userExists(email: String) -> Bool {
        loadUsers().contains {
            $0.email.lowercased() == email.lowercased()
        }
    }

    // MARK: Get exact user from input email
    func getUser(email: String) -> User? {
        loadUsers().first {
            $0.email.lowercased() == email.lowercased()
        }
    }
}
