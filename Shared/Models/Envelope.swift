struct Envelope: Codable {
    let category: Category
    let centAmount: Int
    var centAmountBySubcategories: [Subcategory: Int] = [:]
}
