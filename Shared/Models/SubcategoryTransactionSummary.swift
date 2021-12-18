struct SubcategoryTransactionSummary: Identifiable {
    let subcategory: Subcategory
    var total: CentAmount = 0
    var transactions: [Transaction] = []

    var id: String {
        subcategory.id
    }
}
