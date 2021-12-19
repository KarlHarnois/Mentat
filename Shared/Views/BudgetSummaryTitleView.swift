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
        guard let total = summary?.expenseTotal else { return "—" }
        let formatter = MoneyFormatter(currency: .cad)
        return formatter.string(centAmount: total)
    }
}