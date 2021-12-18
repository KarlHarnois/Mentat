import SwiftUI

struct CategorySummaryProgressView: View {
    let summary: CategoryTransactionSummary

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(uiColor: .secondarySystemGroupedBackground))

            VStack(alignment: .center) {
                ProgressCircle(value: summary.total, total: 50000) {
                    VStack {
                        Text(summary.total.formattedMoney)
                            .bold()

                        Text("/ \(500)")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
                .padding(.vertical, 10)

                Text(summary.category.name)
            }
            .padding()
        }
    }
}
