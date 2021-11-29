struct Transaction: Identifiable, Codable, Equatable {
    let id: String
    let description: String
    let fullDescription: String
    @CapitalizedStringCodable var category: Category?
    @CapitalizedStringCodable var subcategory: Subcategory?
    let centAmount: Int
    let currency: Currency
    let currencyCentAmount: Int
    let source: TransactionSource
    var isExpensed: Bool
    let timestamps: TransactionTimestamps
}
