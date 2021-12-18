import OrderedCollections

struct TransactionSummary {
    var total: CentAmount = 0
    var expenseTotal: CentAmount = 0
    var uncategorizedExpenseTotal: CentAmount = 0
    var transactions: [Transaction] = []
    var categorySections: [CategoryTransactionSummary] = []

    private(set) var subcategoriesByCategory: [Category: OrderedSet<Subcategory>] = [:]
    private(set) var totalPerCategory: [Category: CentAmount] = [:]
    private(set) var uncategorizedTotalByCategory: [Category: CentAmount] = [:]
    private(set) var totalPerSubcategory: [Category: [Subcategory: CentAmount]] = [:]
}
