protocol MoneyFormattable {
    func formattedMoney(decimalStyle: MoneyFormatter.DecimalStyle, currency: Currency?) -> String
}

extension MoneyFormattable {
    func formattedMoney(decimalStyle: MoneyFormatter.DecimalStyle = .short,
                        currency: Currency? = nil) -> String {
        formattedMoney(decimalStyle: decimalStyle, currency: currency)
    }
}

extension Int: MoneyFormattable {
    func formattedMoney(decimalStyle: MoneyFormatter.DecimalStyle, currency: Currency?) -> String {
        let formatter = MoneyFormatter(currency: currency, decimalStyle: decimalStyle)
        return formatter.string(centAmount: self)
    }
}

extension Optional: MoneyFormattable where Wrapped == Int {
    func formattedMoney(decimalStyle: MoneyFormatter.DecimalStyle, currency: Currency?) -> String {
        guard let int = self else {
            return "—"
        }
        return int.formattedMoney(decimalStyle: decimalStyle, currency: currency)
    }
}
