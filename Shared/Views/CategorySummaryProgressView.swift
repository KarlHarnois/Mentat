import SwiftUI

struct CategorySummaryProgressView: View {
    let summary: CategoryTransactionSummary

    var body: some View {
        VStack(alignment: .leading) {
            ProgressView(value: CGFloat(summary.total), total: CGFloat(50000))
                .tint(color(value: summary.total, total: 50000))

            HStack {
                Text(summary.category.name)
                Spacer()
                totalLabel(value: summary.total, total: 50000)
            }
        }
    }

    private func totalLabel(value: Int, total: Int) -> some View {
        HStack(spacing: 0) {
            Text(value.formattedMoney)
                .foregroundColor(color(value: value, total: total))

            Text(" / \(total.formattedMoney)")
                .foregroundColor(.secondary)
        }
    }

    private func color(value: Int, total: Int) -> Color {
        value > total ? .red : .green
    }
}
