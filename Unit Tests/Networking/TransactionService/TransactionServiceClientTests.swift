import XCTest
import Foundation
@testable import Mentat

final class TransactionServiceClientTests: XCTestCase {
    var subject: TransactionServiceClient!
    var session: MockNetworkingSession!

    override func setUp() {
        let url = URL(string: "www.test.com")!

        session = .init()

        subject = .init(props: .init(
            baseURL: url,
            apiKey: "api-key",
            session: session
        ))
    }

    func testPerformReturnsCorrectResponse() async throws {
        let response = try await fetchTransactions()

        XCTAssertEqual(response.transactions.map(\.id), ["1", "2"])
    }

    func testPerformExecutesTheCorrectRequests() async throws {
        _ = try await fetchTransactions()

        XCTAssertEqual(session.requests.map(\.path), ["/sessions", "/transactions"])
        XCTAssertEqual(session.requests.map(\.method), [.post, .get])
    }

    func testPerformCreatesASessionIfNeeded() async throws {
        _ = try await fetchTransactions()

        XCTAssertEqual(session.requests.map(\.headers), [
            ["x-api-key": "api-key"],
            ["x-api-key": "api-key", "Authorization": "session-token"]
        ])
    }

    private func fetchTransactions() async throws -> FetchTransactionRequest.ResponsePayload {
        let sessionRequest = CreateSessionRequest()
        let fetchRequest = FetchTransactionRequest(month: .december, year: 2021)

        session.mockResponse(for: sessionRequest, payload: .success(
            Session(token: "session-token", expiration: Date())
        ))

        session.mockResponse(for: fetchRequest, payload: .success(.init(transactions: [
            try Transaction.create(["id": "1"]),
            try Transaction.create(["id": "2"])
        ])))

        return try await subject.perform(fetchRequest)
    }
}
