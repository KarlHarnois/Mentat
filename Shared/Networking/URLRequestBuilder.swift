import Foundation

struct URLRequestBuilder<R: Request> {
    let configuration: R
    let baseURL: URL

    func build() throws -> URLRequest {
        guard var components = URLComponents(string: baseURL.absoluteString + configuration.path) else {
            throw "Could not initialize \(URLComponents.self) for url \(baseURL.absoluteString)"
        }
        components.queryItems = queryItems
        return try request(for: components)
    }

    private var queryItems: [URLQueryItem]? {
        configuration.queryParams?.map { name, value in
            URLQueryItem(name: name, value: value)
        }
    }

    private func request(for components: URLComponents) throws -> URLRequest {
        guard let url = components.url else {
            throw "Could not create full url for base url \(baseURL.absoluteString)"
        }
        var request = URLRequest(url: url)
        request.httpMethod = configuration.method.rawValue

        configuration.headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}
