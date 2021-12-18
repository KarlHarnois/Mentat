import SwiftUI

struct CategorySummaryProgressView: View {
    let summary: CategoryTransactionSummary

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.systemBackground))

            VStack(alignment: .center) {
                ProgressCircle(value: summary.total, total: 50000) {
                    Text(summary.total.formattedMoney)
                        .bold()
                }

                Text(summary.category.name)
            }
            .padding()
        }
    }
}
