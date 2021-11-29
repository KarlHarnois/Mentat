import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.description)

                categories.map {
                    Text($0)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()
            Text(formattedAmount)
        }
    }

    private var formattedAmount: String {
        let formatter = MoneyFormatter(currency: .cad)
        return formatter.string(centAmount: transaction.centAmount)
    }

    private var categories: String? {
        guard let category = transaction.category else {
            return ""
        }
        return [category.rawValue, transaction.subcategory?.rawValue]
            .compactMap { $0 }
            .joined(separator: " - ")
    }
}
