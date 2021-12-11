import XCTest
@testable import Mentat

final class MonthTests: XCTestCase {
    func testShortName() {
        XCTAssertEqual(Month.allCases.map(\.shortName), [
            "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
        ])
    }

    func testLongName() {
        XCTAssertEqual(Month.allCases.map(\.longName), [
            "January", "February", "March", "April", "May", "June", "July",
            "August", "September", "October", "November", "December"
        ])
    }
}
