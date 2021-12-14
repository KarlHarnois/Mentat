import Foundation

extension Date {
    init?(day: Day, month: Month, year: Int) {
        let calendar = Calendar.current
        let components = DateComponents(calendar: calendar, year: year, month: month.rawValue, day: day)
        guard let date = calendar.date(from: components) else { return nil }
        self = date
    }

    func adding(minutes: Int) -> Date? {
        Calendar.current.date(byAdding: .minute, value: minutes, to: self)
    }

    var day: Day {
        Calendar.current.component(.day, from: self)
    }
}
