enum Category: String, Codable, CaseIterable {
    case food, entertainment, housing, health, transport
}

extension Category: Identifiable {
    var id: String {
        rawValue
    }
}
