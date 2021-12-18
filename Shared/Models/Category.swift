enum Category: String, Codable, CaseIterable {
    case food, entertainment, housing, health, transport

    var name: String {
        rawValue.capitalized
    }
}

extension Category: Identifiable {
    var id: String {
        rawValue
    }
}
