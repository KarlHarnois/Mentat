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
}

extension Array where Element == Transaction {
    func sortedByDay() -> [Day: [Transaction]] {
        reduce([:]) { accumulation, transaction in
            let day = Calendar.current.component(.day, from: transaction.timestamps.postedAt)
            var list = accumulation[day] ?? []

            if let index = list.firstIndex(where: { $0.timestamps.postedAt > transaction.timestamps.postedAt }) {
                list.insert(transaction, at: index)
            } else {
                list.append(transaction)
            }

            var copy = accumulation
            copy[day] = list
            return copy
        }
    }
}
