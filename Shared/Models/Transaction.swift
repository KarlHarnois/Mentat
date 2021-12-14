import Foundation

struct Transaction: Identifiable, Codable, Equatable {
    let id: String
    let description: String
    let fullDescription: String
    @CapitalizedStringCodable var category: Category?
    @CapitalizedStringCodable var subcategory: Subcategory?
    let centAmount: Int
    let currency: Currency
    let currencyCentAmount: Int
    let source: TransactionSource
    var isExpensed: Bool
    let timestamps: TransactionTimestamps

    var day: Day {
        Calendar.current.component(.day, from: timestamps.postedAt)
    }
}

extension Array where Element == Transaction {
    func sortedByDay() -> [Day: [Transaction]] {
        reduce([:]) { accumulation, transaction in
            let day = transaction.day

            var list = accumulation[day] ?? []
            list.insertByPostDate(transaction)

            var copy = accumulation
            copy[day] = list
            return copy
        }
    }

    private mutating func insertByPostDate(_ transaction: Transaction) {
        let index = firstIndex(where: {
            $0.timestamps.postedAt > transaction.timestamps.postedAt
        })

        if let index = index {
            insert(transaction, at: index)
        } else {
            append(transaction)
        }
    }
}
