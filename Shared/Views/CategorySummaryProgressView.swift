import SwiftUI

fileprivate struct Constants {
    static let cornerRadius: CGFloat = 20
}

struct CategorySummaryProgressView: View {
    let state: State

    struct State {
        let title: String
        let imageName: String
        let currentAmount: CentAmount
        let budgetedAmount: CentAmount?
        let transactions: [Transaction]
    }

    init(summary: CategoryTransactionSummary) {
        self.state = .init(
            title: summary.category.name,
            imageName: summary.category.imageName,
            currentAmount: summary.total,
            budgetedAmount: 50000,
            transactions: summary.transactions
        )
    }

    init(uncategorizedTransactions: [Transaction], total: CentAmount) {
        self.state = .init(
            title: "Uncategorized",
            imageName: "questionmark.diamond.fill",
            currentAmount: total,
            budgetedAmount: nil,
            transactions: uncategorizedTransactions
        )
    }

    var body: some View {
        ZStack {
            roundedSquare
            content
        }
    }

    private var roundedSquare: some View {
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .foregroundColor(Color(.secondarySystemGroupedBackground))
            .aspectRatio(1, contentMode: .fit)
    }

    private var content: some View {
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 15) {
                progressCircle
                    .frame(width: geo.size.width * 0.50, alignment: .center)

                VStack(spacing: 0) {
                    Text(state.title)

                    Text(amountLabel)
                        .foregroundColor(.secondary)
                        .font(.callout)
                }
            }
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }

    private var amountLabel: String {
        if let budget = state.budgetedAmount {
            return "\(state.currentAmount.formattedMoney) / \(budget.formattedMoney)"
        } else {
            return state.currentAmount.formattedMoney
        }
    }

    private var progressCircle: some View {
        ProgressCircle(value: state.currentAmount, total: state.budgetedAmount) {
            icon
        }
    }

    private var icon: some View {
        Image(systemName: state.imageName)
            .font(.title)
    }
}
