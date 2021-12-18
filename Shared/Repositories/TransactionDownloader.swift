actor TransactionDownloader {
    private let client: TransactionServiceClient

    init(client: TransactionServiceClient) {
        self.client = client
    }

    struct Response {
        let summary: TransactionSummary
        let transactions: [Transaction]
    }

    func fetchTransaction(month: Month, year: Int) async throws -> Response {
        let request = FetchTransactionRequest(month: month, year: year)
        let transactions = try await self.client.perform(request).transactions
        let summary = TransactionSummaryBuilder().summary(for: transactions)
        return Response(summary: summary, transactions: transactions)
    }
}
