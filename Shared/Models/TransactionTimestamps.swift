import Foundation

struct TransactionTimestamps: Codable, Equatable {
    let createdAt: Date
    let updatedAt: Date
    let postedAt: Date
    let deletedAt: Date?
    let authorizedAt: Date
}

#if DEBUG

extension TransactionTimestamps {

    static func create(createdAt: Date = .init(),
                       updatedAt: Date = .init(),
                       postedAt: Date = .init(),
                       deletedAt: Date = .init(),
                       authorizedAt: Date = .init()) -> Self {
        .init(
            createdAt: createdAt,
            updatedAt: updatedAt,
            postedAt: postedAt,
            deletedAt: deletedAt,
            authorizedAt: authorizedAt
        )
    }
}

#endif
