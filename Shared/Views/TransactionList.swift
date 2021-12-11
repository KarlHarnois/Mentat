import SwiftUI

struct TransactionList: View {
    let transactions: [Transaction]
    let style: Style

    enum Style {
        case fullDescription
    }

    var body: some View {
        List(transactions) { transaction in
            TransactionRow(transaction: transaction)
        }
    }
}
