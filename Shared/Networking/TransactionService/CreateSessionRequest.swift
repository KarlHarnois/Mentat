struct CreateSessionRequest: TransactionServiceRequest {
    typealias ResponsePayload = Session

    let method: HTTPMethod = .post
    let path = "/sessions"
    var headers = [String: String]()
}
