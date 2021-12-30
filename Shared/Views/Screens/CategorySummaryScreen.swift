import SwiftUI

struct CategorySummaryScreen: View {
    let state: State

    struct State {
        let title: String
        let transactions: [Transaction]
    }

    init(summary: CategoryTransactionSummary) {
        state = .init(
            title: summary.category.name,
            transactions: summary.transactions
        )
    }

    init(uncategorizedTransactions: [Transaction]) {
        state = .init(title: "Uncategorized", transactions: uncategorizedTransactions)
    }

    var body: some View {
        TransactionList(transactions: state.transactions)
            .navigationTitle(state.title)
    }
}
