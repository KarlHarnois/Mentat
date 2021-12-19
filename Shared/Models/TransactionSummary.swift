struct TransactionSummary {
    var total: CentAmount = 0
    var expenseTotal: CentAmount = 0
    var uncategorizedExpenseTotal: CentAmount = 0
    var transactions: [Transaction] = []
    var uncategorizedTransactions: [Transaction] = []
    var categorySections: [CategoryTransactionSummary] = []
}
