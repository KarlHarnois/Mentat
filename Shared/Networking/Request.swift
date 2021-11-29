import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol Request: AnyRequest {
    associatedtype ResponsePayload: Decodable

    var path: String { get }
    var method: HTTPMethod { get }
    var queryParams: [String: String]? { get }
    var headers: [String: String] { get set }
}

extension Request {
    var queryParams: [String: String]? { nil }

    func build(baseURL: URL) throws -> URLRequest {
        let builder = URLRequestBuilder(configuration: self, baseURL: baseURL)
        return try builder.build()
    }

    func eraseToAnyRequest() -> AnyRequest {
        self
    }
}

protocol AnyRequest {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParams: [String: String]? { get }
    var headers: [String: String] { get }
}
