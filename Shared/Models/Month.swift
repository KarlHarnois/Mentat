import Foundation

enum Month: Int, CaseIterable, Codable {
    case january = 1,
         february,
         march,
         april,
         may,
         june,
         july,
         august,
         september,
         october,
         november,
         december

    var shortName: String {
        formatter.shortMonthSymbols[index]
    }

    var longName: String {
        formatter.monthSymbols[index]
    }

    private var index: Int {
        rawValue - 1
    }

    private var formatter: DateFormatter {
        .init()
    }
}
