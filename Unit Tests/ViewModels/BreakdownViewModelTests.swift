import XCTest
import Combine
@testable import Mentat

@MainActor final class BreakdownViewModelTests: XCTestCase {
    var subject: BreakdownViewModel!
    var storage: MockStorage!
    var session: MockNetworkingSession!
    var settings: Settings!
    var cancellables: Set<AnyCancellable>!

    @MainActor override func setUp() {
        storage = .init()
        session = .init()
        settings = .init()
        cancellables = .init()

        let client = TransactionServiceClient(props: .init(
            baseURL: URL(string: "www.test.com")!,
            apiKey: "api-key",
            session: session,
            logger: nil
        ))

        let transactionRepo = TransactionRepository(client: client)
        let envelopeRepo = EnvelopeRepository(storage: storage)

        subject = .init(props: .init(
            transactionRepo: transactionRepo,
            envelopeRepo: envelopeRepo,
            settings: settings
        ))
    }

    func testMonthYearState() {
        let expected = MonthYear(month: .january, year: 1990)
        let expectation = XCTestExpectation()

        subject
            .$state
            .map(\.monthYear)
            .filter { $0 == expected }
            .sink {
                XCTAssertEqual($0, expected)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        settings.monthYear = expected
        wait(for: [expectation], timeout: 5)
    }
}
