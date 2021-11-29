import Foundation

struct TransactionTimestamps: Codable, Equatable {
    let createdAt: Date?
    let updatedAt: Date?
    let postedAt: Date
    let deletedAt: Date?
    let authorizedAt: Date?
}
