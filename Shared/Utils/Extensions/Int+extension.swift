extension Int {
    var formattedMoney: String {
        MoneyFormatter().string(centAmount: self)
    }
}
