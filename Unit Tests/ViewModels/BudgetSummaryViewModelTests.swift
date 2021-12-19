import XCTest
import Combine
@testable import Mentat

@MainActor final class BudgetSummaryViewModelTests: XCTestCase {
    var subject: BudgetSummaryViewModel!
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

        settings.monthYear = expected

        assertStateMatches { state in
            state.monthYear == expected
        }
    }

    private func assertStateMatches(matcher: @escaping (BudgetSummaryViewModel.State) -> Bool) {
        let expectation = XCTestExpectation()

        subject
            .$state
            .filter(matcher)
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }
}
