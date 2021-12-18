struct SubcategoryTransactionSummary {
    let subcategory: Subcategory
    var total: CentAmount = 0
    var transactions: [Transaction] = []
}
