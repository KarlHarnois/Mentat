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
        let formatter = DateFormatter()
        let index = rawValue - 1
        return formatter.shortMonthSymbols[index]
    }

    var longName: String {
        let formatter = DateFormatter()
        let index = rawValue - 1
        return formatter.monthSymbols[index]
    }
}
