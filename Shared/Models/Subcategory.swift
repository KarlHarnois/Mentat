enum Subcategory: String, Codable, CaseIterable {
    case grocery, restaurant, furniture, alcool,
         pharmacy, clothing, healthcare, mtg,
         coffee
}

extension Subcategory: Identifiable {
    var id: String {
        rawValue
    }
}
