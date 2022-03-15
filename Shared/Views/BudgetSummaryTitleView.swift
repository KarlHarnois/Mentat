import SwiftUI

struct BudgetSummaryTitleView: View {
    let summary: TransactionSummary?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Expense Total")
                .foregroundColor(.secondary)

            Text(formattedTotal)
                .bold()
                .font(.system(size: 45))
                .foregroundColor(.primary)
        }
    }

    private var formattedTotal: String {
        (summary?.expenseTotal).formattedMoney(currency: .cad)
    }
}
