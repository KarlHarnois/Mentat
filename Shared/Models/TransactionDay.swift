struct TransactionDay: Identifiable {
    let day: Day
    let transactions: [Transaction]

    public var id: Int {
        day
    }
}
