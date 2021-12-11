import XCTest
@testable import Mentat

final class MonthYearTests: XCTestCase {
    func testFormattedShort() {
        let subject = MonthYear(month: .august, year: 2021)
        XCTAssertEqual(subject.formatted(.short), "Aug 2021")
    }
}
