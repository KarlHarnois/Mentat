import XCTest
@testable import Mentat

final class MoneyFormattableTests: XCTestCase {
    func testNilOptionalInt() {
        let subject: Int? = nil
        XCTAssertEqual(subject.formattedMoney(), "—")
    }

    func testNonNilOptionalInt() {
        let subject: Int? = 1000
        XCTAssertEqual(subject.formattedMoney(currency: .cad), "10$")
    }

    func testInt() {
        let subject = 5000
        XCTAssertEqual(subject.formattedMoney(decimalStyle: .long), "50.00")
    }
}
