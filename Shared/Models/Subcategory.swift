enum Subcategory: String, Codable, CaseIterable {
    case grocery, restaurant, furniture, alcool,
         pharmacy, clothing, healthcare, mtg,
         coffee

    var name: String {
        rawValue.capitalized
    }
}

extension Subcategory: Identifiable {
    var id: String {
        rawValue
    }
}
