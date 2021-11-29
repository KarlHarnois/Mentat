struct FetchTransactionRequest: TransactionServiceRequest {
    typealias ResponsePayload = Response

    let method = HTTPMethod.get
    let path = "/transactions"
    let month: Month
    let year: Int
    var headers = [String: String]()

    var queryParams: [String : String]? {
        [
            "month": String(month.rawValue),
            "year": String(year)
        ]
    }

    struct Response: Codable {
        let transactions: [Transaction]
    }
}
