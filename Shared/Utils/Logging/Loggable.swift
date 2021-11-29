import Foundation

protocol Loggable {
    var loggerCategory: LoggerCategory { get }
    var loggerAttributes: [LoggerEventAttribute: String?] { get }
}

extension URLRequest: Loggable {
    var loggerCategory: LoggerCategory {
        .networking
    }

    var loggerAttributes: [LoggerEventAttribute: String?] {
        [
            .url: url?.absoluteString,
            .curl: CurlBuilder().curlString(for: self),
            .httpMethod: httpMethod,
            .subcategory: "request"
        ]
    }
}
