import Foundation

struct Transaction: Identifiable, Codable, Equatable {
    let id: String
    let description: String
    let fullDescription: String
    @CapitalizedStringCodable var category: Category?
    @CapitalizedStringCodable var subcategory: Subcategory?
    let centAmount: CentAmount
    let currency: Currency
    let currencyCentAmount: CentAmount
    let source: TransactionSource
    let isExpensed: Bool
    let timestamps: TransactionTimestamps

    var isPersonalExpense: Bool {
        centAmount > 0 && !isExpensed
    }
}

extension Array where Element == Transaction {
    func sortedByDay() -> [Day: [Transaction]] {
        reduce([:]) { accumulation, transaction in
            let day = transaction.timestamps.authorizedAt.day

            var list = accumulation[day] ?? []
            list.insertByAuthorizationDate(transaction)

            var copy = accumulation
            copy[day] = list
            return copy
        }
    }

    private mutating func insertByAuthorizationDate(_ transaction: Transaction) {
        let index = firstIndex(where: {
            $0.timestamps.authorizedAt > transaction.timestamps.authorizedAt
        })

        if let index = index {
            insert(transaction, at: index)
        } else {
            append(transaction)
        }
    }
}

#if DEBUG

extension Transaction {
    static func create(id: String = "id",
                       description: String = "description",
                       fullDescription: String = "fullDescription",
                       category: Category? = nil,
                       subcategory: Subcategory? = nil,
                       centAmount: Int = 0,
                       currency: Currency = .cad,
                       currencyCentAmount: Int = 0,
                       source: TransactionSource = .init(name: "name", last4: nil),
                       isExpensed: Bool = false,
                       timestamps: TransactionTimestamps = .create()) -> Self {
        .init(
            id: id,
            description: description,
            fullDescription: fullDescription,
            category: category,
            subcategory: subcategory,
            centAmount: centAmount,
            currency: currency,
            currencyCentAmount: currencyCentAmount,
            source: source,
            isExpensed: isExpensed,
            timestamps: timestamps
        )
    }
}

#endif
