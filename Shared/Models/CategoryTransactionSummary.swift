struct CategoryTransactionSummary: Identifiable {
    let category: Category
    var total: CentAmount = 0
    var uncategorizedTotal: CentAmount = 0
    var transactions: [Transaction] = []
    var subcategories: [SubcategoryTransactionSummary] = []

    var id: String {
        category.id
    }
}
