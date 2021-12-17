actor TransactionDownloader {
    private let client: TransactionServiceClient

    init(client: TransactionServiceClient) {
        self.client = client
    }

    struct Response {
        let breakdown: TransactionSummary
        let transactions: [Transaction]
    }

    func fetchTransaction(month: Month, year: Int) async throws -> Response {
        let request = FetchTransactionRequest(month: month, year: year)
        let transactions = try await self.client.perform(request).transactions
        let breakdown = TransactionSummary(transactions: transactions)
        return Response(breakdown: breakdown, transactions: transactions)
    }
}
