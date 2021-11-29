import Combine
import Foundation
@testable import Mentat

final class MockNetworkingSession: NetworkingSession {
    private(set) var requests = [AnyRequest]()

    private var payloadByRequest = [String: Result<Any, Error>]()

    func mockResponse<R: Request>(for request: R, payload: Result<R.ResponsePayload, Error>) {
        payloadByRequest[key(for: request)] = payload.map { $0 as Any }
    }

    func data<R: Request>(for request: R, baseURL: URL, logger: Logger?) async throws -> R.ResponsePayload {
        requests.append(request.eraseToAnyRequest())

        let payload = payloadByRequest[key(for: request)]

        switch payload {
        case .success(let response):
            return response as! R.ResponsePayload
        case .failure(let error):
            throw error
        case .none:
            throw "Mock response payload not found for request: \(key(for: request))"
        }
    }

    private func key<R: Request>(for request: R) -> String {
        "\(request.method.rawValue) \(request.path)"
    }
}
