import SwiftUI

fileprivate struct Constants {
    static let cornerRadius: CGFloat = 20
}

struct CategorySummaryProgressView: View {
    let summary: CategoryTransactionSummary

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
                    .frame(width: geo.size.width * 0.55, alignment: .center)

                Text(summary.category.name)
            }
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }

    private var progressCircle: some View {
        ProgressCircle(value: summary.total, total: 50000) {
            VStack {
                Text(summary.total.formattedMoney)
                    .bold()

                Text("/ \(500)")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
    }
}
