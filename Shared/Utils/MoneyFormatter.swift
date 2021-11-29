import Foundation

struct MoneyFormatter {
    var currency: Currency?

    func string(centAmount: Int) -> String {
        var output = decimal(centAmount)

        if let currency = currency {
            switch currency {
            case .cad:
                output += symbol
            case .usd:
                output = symbol + output
            }
        }

        if centAmount < 0 {
            output = "-" + output
        }

        return output
    }

    private var symbol: String {
        "$"
    }

    private func decimal(_ centAmount: Int) -> String {
        let decimal = NSDecimalNumber(value: centAmount).dividing(by: 100)
        let str = String(format: "%.2f", decimal.doubleValue)

        if centAmount >= 0 {
            return str
        } else {
            return String(str.dropFirst())
        }
    }
}
