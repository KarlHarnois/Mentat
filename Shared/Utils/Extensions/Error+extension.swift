import Foundation

extension Error {
    var identifiable: IdentifiableError {
        .init(wrapped: self)
    }
}

struct IdentifiableError: LocalizedError, Identifiable {
    let wrapped: Error

    var errorDescription: String? {
        wrapped.localizedDescription
    }

    var id: String {
        wrapped.localizedDescription
    }
}
