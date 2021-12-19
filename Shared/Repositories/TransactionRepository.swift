import Foundation

@MainActor final class TransactionRepository: ObservableObject {
    @Published private(set) var summaryByMonthYear: [MonthYear: TransactionSummary] = [:]
    @Published private(set) var transactionsByMonthYear: [MonthYear: [Transaction]] = [:]

    private let client: TransactionServiceClient

    init(client: TransactionServiceClient) {
        self.client = client
    }

    func fetchTransactions(monthYear: MonthYear) async throws {
        let downloader = TransactionDownloader(client: client)
        let response = try await downloader.fetchTransaction(month: monthYear.month, year: monthYear.year)

        transactionsByMonthYear[monthYear] = response.transactions
        summaryByMonthYear[monthYear] = response.summary
    }
}
