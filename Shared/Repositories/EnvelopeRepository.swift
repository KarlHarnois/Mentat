import Combine
import Foundation

@MainActor final class EnvelopeRepository: ObservableObject {
    @Published private(set) var envelopes: [Category: Envelope] = [:]

    private let storage: Storage

    init(storage: Storage) {
        self.storage = storage
    }

    func save(_ envelopes: [Envelope]) async throws {
        fatalError("Implement me")
    }

    func save(_ envelope: Envelope) async throws {
        envelopes[envelope.category] = envelope
        try await interactor.save(envelope)
        try await refreshEnvelopes()
    }

    func refreshEnvelopes() async throws {
        envelopes = try await interactor.fetchEnvelopes()
    }

    private var interactor: EnvelopeInteractor {
        .init(storage: storage)
    }
}
