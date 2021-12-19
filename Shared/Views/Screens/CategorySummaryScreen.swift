import SwiftUI

struct CategorySummaryScreen: View {
    let summary: CategoryTransactionSummary

    var body: some View {
        TransactionList(transactions: summary.transactions)
            .navigationTitle(summary.category.name)
    }
}
