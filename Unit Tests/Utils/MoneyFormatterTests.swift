import XCTest
@testable import Mentat

final class MoneyFormatterTests: XCTestCase {
    func testShortDecimalStyle() {
        let formatter = MoneyFormatter(decimalStyle: .short)
        XCTAssertEqual(formatter.string(centAmount: 100000), "1000")
        XCTAssertEqual(formatter.string(centAmount: 100050), "1000.50")
    }

    func testLongDecimalStyle() {
        let formatter = MoneyFormatter(decimalStyle: .long)
        XCTAssertEqual(formatter.string(centAmount: 100000), "1000.00")
        XCTAssertEqual(formatter.string(centAmount: 100050), "1000.50")
    }
}
