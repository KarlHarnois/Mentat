import Foundation

struct Session: Codable {
    let token: String
    let expiration: Date
}
