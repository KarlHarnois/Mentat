import Foundation
import Combine

protocol TransactionServiceRequest: Request {}

struct TransactionServiceProps {
    let baseURL: URL
    let apiKey: String
    let session: NetworkingSession
    var logger: Logger?
}

final class TransactionServiceClient: ObservableObject {
    private let props: TransactionServiceProps
    private var session: Session?

    init(props: TransactionServiceProps) {
        self.props = props
    }

    func perform<R: TransactionServiceRequest>(_ request: R) async throws -> R.ResponsePayload {
        if session == nil {
            try await createSession()
        }
        return try await performRequest(request)
    }

    private func createSession() async throws {
        session = try await performRequest(CreateSessionRequest())
    }

    private func performRequest<R: Request>(_ request: R) async throws -> R.ResponsePayload {
        var request = request
        request.headers["x-api-key"] = props.apiKey
        request.headers["Authorization"] = session?.token
        return try await props.session.data(for: request, baseURL: props.baseURL, logger: props.logger)
    }
}
