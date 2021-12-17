struct CategoryTransactionSummary {
    let category: Category
    let total: CentAmount
    let uncategorizedTotal: CentAmount
    let transactions: [Transaction]
    let subcategories: [SubcategoryTransactionSummary]
}
