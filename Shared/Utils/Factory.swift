import Foundation

protocol Factory: Decodable {
    static var defaultParams: [String: Any] { get }
}

extension Factory {
    static func create(_ params: [String: Any]) throws -> Self {
        let params = params.merging(defaultParams, uniquingKeysWith: { current, _ in current })
        let data = try JSONSerialization.data(withJSONObject: params, options: [])
        return try JSONDecoder.custom.decode(Self.self, from: data)
    }
}

extension Transaction: Factory {
    static var defaultParams: [String: Any] {
        [
            "id": "",
            "description": "",
            "fullDescription": "",
            "centAmount": 0,
            "currency": "USD",
            "currencyCentAmount": 0,
            "isExpensed": false,
            "source": [
                "name": ""
            ],
            "timestamps": [
                "postedAt": 1638165004910
            ]
        ]
    }
}
