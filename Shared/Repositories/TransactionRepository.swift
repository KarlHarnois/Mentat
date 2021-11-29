import Foundation

@MainActor final class TransactionRepository: ObservableObject {
    @Published private(set) var categoryBreakdownByMonthYear: [MonthYear: CategoryBreakdownReport] = [:]
    @Published private(set) var transactionsByMonthYear: [MonthYear: [Transaction]] = [:]

    private let client: TransactionServiceClient

    init(client: TransactionServiceClient) {
        self.client = client
    }

    func fetchTransactions(month: Month, year: Int) async throws {
        let downloader = TransactionDownloader(client: client)
        let response = try await downloader.fetchTransaction(month: month, year: year)
        let key = MonthYear(month: month, year: year)

        transactionsByMonthYear[key] = response.transactions
        categoryBreakdownByMonthYear[key] = response.breakdown
    }
}
