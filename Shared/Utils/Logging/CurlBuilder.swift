import Foundation

struct CurlBuilder {
    func curlString(for request: URLRequest) -> String {
        let newLine = " \\\n"
        let components = curlComponents(for: request).map(\.option)
        return "curl " + components.joined(separator: newLine)
    }

    func curlComponents(for request: URLRequest) -> [CurlComponent] {
        var components: [CurlComponent] = [
            .url(request.url),
            .method(request.httpMethod)
        ]

        if let httpHeaders = request.allHTTPHeaderFields, !httpHeaders.keys.isEmpty {
            for (key, value) in httpHeaders {
                if redactedHeaderKeys.contains(key) {
                    components.append(.redactedHeader(key: key))
                } else {
                    components.append(.header(key: key, value: value))
                }
            }
        }

        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8), !bodyString.isEmpty {
            components.append(.body(bodyString))
        }

        return components
    }

    private var redactedHeaderKeys: [String] {
        [
            "x-api-key",
            "Authorization"
        ]
    }
}
