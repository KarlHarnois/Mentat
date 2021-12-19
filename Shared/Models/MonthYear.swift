struct MonthYear: Hashable, Codable {
    let month: Month
    let year: Int

    enum FormatStyle {
        case short
    }

    func formatted(_ style: FormatStyle) -> String {
        switch style {
        case .short:
            return month.shortName + " " + String(year)
        }
    }

    var previousMonth: MonthYear {
        if month == .january {
            return MonthYear(month: .december, year: year - 1)
        } else {
            let previousMonth = Month.allCases[month.rawValue - 2]
            return MonthYear(month: previousMonth, year: year)
        }
    }

    var nextMonth: MonthYear {
        if month == .december {
            return MonthYear(month: .january, year: year + 1)
        } else {
            let nextMonth = Month.allCases[month.rawValue]
            return MonthYear(month: nextMonth, year: year)
        }
    }
}
