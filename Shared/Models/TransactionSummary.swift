import OrderedCollections
import Foundation

struct TransactionSummary {
    let transactions: [Transaction]
    let categories = Category.allCases

    private(set) var total = 0
    private(set) var expenseTotal = 0
    private(set) var uncategorizedExpenseTotal = 0

    private(set) var subcategoriesByCategory: [Category: OrderedSet<Subcategory>] = [:]
    private(set) var totalPerCategory: [Category: CentAmount] = [:]
    private(set) var uncategorizedTotalByCategory: [Category: CentAmount] = [:]
    private(set) var totalPerSubcategory: [Category: [Subcategory: CentAmount]] = [:]

    init(transactions: [Transaction]) {
        self.transactions = transactions

        transactions.forEach { transaction in
            compute(transaction)
        }
    }

    private mutating func compute(_ transaction: Transaction) {
        total += transaction.centAmount

        if isExpense(transaction) {
            addToExpenseAmount(transaction)
        }

        guard let category = transaction.category else {
            if isExpense(transaction) {
                addToUncategorizedExpense(transaction)
            }
            return
        }
        addToTotals(by: category, amount: transaction.centAmount)

        guard let subcategory = transaction.subcategory else {
            addToUncategorizedTotals(by: category, amount: transaction.centAmount)
            return
        }
        add(subcategory, to: category)
        addToTotals(by: subcategory, in: category, amount: transaction.centAmount)
    }

    private func isExpense(_ transaction: Transaction) -> Bool {
        transaction.centAmount > 0 && !transaction.isExpensed
    }

    private mutating func addToExpenseAmount(_ transaction: Transaction) {
        expenseTotal += transaction.centAmount
    }

    private mutating func addToUncategorizedExpense(_ transaction: Transaction) {
        uncategorizedExpenseTotal += transaction.centAmount
    }

    private mutating func addToTotals(by category: Category, amount: Int) {
        totalPerCategory[category] = (totalPerCategory[category] ?? 0) + amount
    }

    private mutating func addToUncategorizedTotals(by category: Category, amount: Int) {
        uncategorizedTotalByCategory[category] = (uncategorizedTotalByCategory[category] ?? 0) + amount
    }

    private mutating func add(_ subcategory: Subcategory, to category: Category) {
        var subs = subcategoriesByCategory[category] ?? .init()
        subs.append(subcategory)
        subcategoriesByCategory[category] = subs
    }

    private mutating func addToTotals(by subcategory: Subcategory, in category: Category, amount: Int) {
        if totalPerSubcategory[category] == nil {
            totalPerSubcategory[category] = [:]
        }
        var copy = totalPerSubcategory[category]?[subcategory] ?? 0
        copy += amount
        totalPerSubcategory[category]?[subcategory] = copy
    }
}
