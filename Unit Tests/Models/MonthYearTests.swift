import XCTest
@testable import Mentat

final class MonthYearTests: XCTestCase {
    func testFormattedShort() {
        let subject = MonthYear(month: .august, year: 2021)
        XCTAssertEqual(subject.formatted(.short), "Aug 2021")
    }

    func testPreviousMonth() {
        let january = MonthYear(month: .january, year: 2020)
        XCTAssertEqual(january.previousMonth, MonthYear(month: .december, year: 2019))

        let february = MonthYear(month: .february, year: 1990)
        XCTAssertEqual(february.previousMonth, MonthYear(month: .january, year: 1990))
    }

    func testNextMonth() {
        let december = MonthYear(month: .december, year: 2021)
        XCTAssertEqual(december.nextMonth, MonthYear(month: .january, year: 2022))

        let october = MonthYear(month: .october, year: 2021)
        XCTAssertEqual(october.nextMonth, MonthYear(month: .november, year: 2021))
    }
}
