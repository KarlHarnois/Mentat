import Foundation

@propertyWrapper
struct CapitalizedStringCodable<A: Codable & RawRepresentable & Equatable>: Equatable
where A.RawValue == String {

    var wrappedValue: A?

    init(wrappedValue: A?) {
        self.wrappedValue = wrappedValue
    }
}

extension CapitalizedStringCodable: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        guard let rawValue = try? container.decode(String.self) else { return }
        self.wrappedValue = .init(rawValue: rawValue.lowercased())
    }

    func encode(to encoder: Encoder) throws {
        guard let rawValue = wrappedValue?.rawValue else { return }
        var container = encoder.singleValueContainer()
        try container.encode(rawValue.capitalized)
    }
}

extension KeyedDecodingContainer {
    func decode<A>(_ type: CapitalizedStringCodable<A>.Type, forKey key: Self.Key) throws -> CapitalizedStringCodable<A>
    where A: Codable & RawRepresentable & Equatable {
        try decodeIfPresent(type, forKey: key) ?? .init(wrappedValue: nil)
    }
}
