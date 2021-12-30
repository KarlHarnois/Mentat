import SwiftUI

struct TransactionList: View {
    let transactions: [Transaction]

    var body: some View {
        List {
            ForEach(transactionDays) { day in
                section(for: day)
            }
        }
    }

    private func section(for transactionDay: TransactionDay) -> some View {
        Section(header: Text(String(transactionDay.day))) {
            ForEach(transactionDay.transactions) { transaction in
                TransactionRow(transaction: transaction, components: [])
            }
        }
    }

    private var transactionDays: [TransactionDay] {
        transactions
            .sortedByDay()
            .map { day, transactions in
                TransactionDay(day: day, transactions: transactions)
            }
            .sorted(by: { $0.day < $1.day })
    }
}
