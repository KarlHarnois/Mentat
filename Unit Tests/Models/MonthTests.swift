import XCTest
@testable import Mentat

final class MonthTests: XCTestCase {
    func testShortName() {
        XCTAssertEqual(Month.allCases.map(\.shortName), [
            "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
        ])
    }
}
