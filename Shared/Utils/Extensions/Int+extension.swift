extension Int {
    var formattedMoney: String {
        MoneyFormatter(decimalStyle: .short).string(centAmount: self)
    }
}
