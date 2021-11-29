import OrderedCollections

struct CategoryBreakdownReport {
    let transactions: [Transaction]
    let categories = Category.allCases

    private(set) var total = 0
    private(set) var expenseTotal = 0
    private(set) var uncategorizedExpenseTotal = 0

    private(set) var subcategoriesByCategory: [Category: OrderedSet<Subcategory>] = [:]
    private(set) var totalPerCategory: [Category: Int] = [:]
    private(set) var uncategorizedTotalByCategory: [Category: Int] = [:]
    private(set) var totalPerSubcategory: [Category: [Subcategory: Int]] = [:]

    init(transactions: [Transaction]) {
        self.transactions = transactions

        transactions.forEach { transaction in
            total += transaction.centAmount

            if transaction.centAmount > 0 && !transaction.isExpensed {
                expenseTotal += transaction.centAmount
            }

            guard let category = transaction.category else {
                if transaction.centAmount > 0 {
                    uncategorizedExpenseTotal += transaction.centAmount
                }
                return
            }

            totalPerCategory[category] = (totalPerCategory[category] ?? 0) + transaction.centAmount

            guard let subcategory = transaction.subcategory else {
                uncategorizedTotalByCategory[category] = (uncategorizedTotalByCategory[category] ?? 0) + transaction.centAmount
                return
            }

            var subs = subcategoriesByCategory[category] ?? .init()
            subs.append(subcategory)
            subcategoriesByCategory[category] = subs

            if totalPerSubcategory[category] == nil {
                totalPerSubcategory[category] = [:]
            }

            var copy = totalPerSubcategory[category]?[subcategory] ?? 0
            copy += transaction.centAmount
            totalPerSubcategory[category]?[subcategory] = copy
        }
    }
}
