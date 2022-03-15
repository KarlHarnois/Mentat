import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    var components = Component.allCases

    enum Component: CaseIterable {
        case category
    }

    var body: some View {
        HStack {
            leftStack
            Spacer()
            Text(formattedAmount)
        }
        .padding(.vertical, 5)
        .onAppear {
            print(transaction.timestamps.authorizedAt)
        }
    }

    private var leftStack: some View {
        VStack(alignment: .leading) {
            Text(transaction.description)

            Group {
                Text(transaction.timestamps.postedAt.description)
                Text(transaction.id)

                if components.contains(.category) {
                    categoryLabel
                }
            }
            .foregroundColor(.secondary)
            .font(.caption)
        }
    }

    private var categoryLabel: some View {
        Group {
            categories.map {
                Text($0)
            }
        }
    }

    private var formattedAmount: String {
        transaction.centAmount.formattedMoney(currency: .cad)
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
