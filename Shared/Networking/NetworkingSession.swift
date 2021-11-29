import Foundation

protocol NetworkingSession {
    func data<R: Request>(for request: R, baseURL: URL, logger: Logger?) async throws -> R.ResponsePayload
}

extension URLSession: NetworkingSession {
    func data<R: Request>(for request: R, baseURL: URL, logger: Logger?) async throws -> R.ResponsePayload {
        let urlRequest = try request.build(baseURL: baseURL)
        logger?.log(urlRequest)
        let (data, response) = try await data(for: urlRequest)
        log(data, response, logger)
        let decoder = JSONDecoder.custom
        let payload = try decoder.decode(R.ResponsePayload.self, from: data)
        return payload
    }

    private func log(_ data: Data?, _ response: URLResponse, _ logger: Logger?) {
        guard let logger = logger else { return }
        guard let response = response as? HTTPURLResponse else { return }

        let json = data.flatMap { data in
            String(data: data, encoding: .utf8)
        }

        let event = LoggerEvent(category: .networking, attributes: [
            .subcategory: "response",
            .statusCode: String(response.statusCode),
            .url: response.url?.absoluteString,
            .payload: json
        ])

        logger.log(event)
    }
}
