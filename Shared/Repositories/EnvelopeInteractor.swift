import Foundation

actor EnvelopeInteractor {
    private let storage: Storage
    private let storageKeyPrefix = "MENTAT_ENVELOPES"

    init(storage: Storage) {
        self.storage = storage
    }

    func fetchEnvelopes() async throws -> [Category: Envelope] {
        var envelopes: [Category: Envelope] = [:]

        for category in Category.allCases {
            guard let data = storage.data(forKey: key(for: category)) else { break }
            let envelope = try JSONDecoder.custom.decode(Envelope.self, from: data)
            envelopes[envelope.category] = envelope
        }

        return envelopes
    }

    func save(_ envelope: Envelope) async throws {
        let data = try JSONEncoder.custom.encode(envelope)
        storage.save(data, forKey: key(for: envelope.category))
    }

    private func key(for category: Category) -> String {
        storageKeyPrefix + "_" + category.rawValue.uppercased()
    }
}
