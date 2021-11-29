import Foundation

enum CurlComponent {
    case url(URL?)
    case method(String?)
    case header(key: String, value: String)
    case redactedHeader(key: String)
    case body(String)

    var option: String {
        switch self {
        case .url(let url):
            return "-i '\(url?.absoluteString ?? "")'"
        case .method(let method):
            return "-X \(method ?? "GET")"
        case let .header(key, value):
            return "-H '\(key): \(value)'"
        case let .redactedHeader(key):
            return "-H '\(key): <REDACTED>'"
        case .body(let data):
            return "--data '\(data)'"
        }
    }
}
