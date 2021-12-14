import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack {
            leftStack
            Spacer()
            Text(formattedAmount)
        }
    }

    private var leftStack: some View {
        VStack(alignment: .leading) {
            Text(transaction.description)
            idLabel
            categoryLabel
        }
    }

    private var idLabel: some View {
        Text(transaction.id)
            .foregroundColor(.secondary)
            .font(.caption)
    }

    private var categoryLabel: some View {
        Group {
            categories.map {
                Text($0)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var formattedAmount: String {
        let formatter = MoneyFormatter(currency: .cad)
        return formatter.string(centAmount: transaction.centAmount)
    }

    private var categories: String? {
        guard let category = transaction.category else {
            return nil
        }
        return [category.rawValue, transaction.subcategory?.rawValue]
            .compactMap { $0 }
            .joined(separator: " - ")
    }
}
