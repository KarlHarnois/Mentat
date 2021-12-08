struct MonthYear: Hashable {
    let month: Month
    let year: Int

    enum FormatStyle {
        case short
    }

    func formatted(_ style: FormatStyle) -> String {
        switch style {
        case .short:
            return month.shortName + " " + String(year).dropFirst(2)
        }
    }
}
