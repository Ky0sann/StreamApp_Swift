import Foundation

struct User: Codable {
    var email: String
    var username: String
    var password: String
    var bio: String?
}
