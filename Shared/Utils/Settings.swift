import Foundation

final class Settings: ObservableObject {
    @Published var monthYear: MonthYear

    init?() {
        let date = Date()
        let components = Calendar.current.dateComponents([.month, .year], from: date)

        guard let month = components.month.flatMap(Month.init),
              let year = components.year else { return nil }

        self.monthYear = .init(month: month, year: year)
    }

    func goToPreviousMonth() {
        monthYear = monthYear.previousMonth
    }

    func goToNextMonth() {
        monthYear = monthYear.nextMonth
    }
}
