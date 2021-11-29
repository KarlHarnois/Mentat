import XCTest
@testable import Mentat

final class SecretsTests: XCTestCase {
    func testTransactionServiceBaseURL() {
        XCTAssertNotNil(try Secrets.transactionServiceBaseURL.read())
    }
}
