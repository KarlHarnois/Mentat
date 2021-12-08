import SwiftUI

struct RootView: View {
    private var settings = Settings()!

    @MainActor private var transactionRepo: TransactionRepository = {
        let url = try! Secrets.transactionServiceBaseURL.read()
        let apiKey = try! Secrets.transactionServiceApiKey.read()

        let client = TransactionServiceClient(props: .init(
            baseURL: URL(string: url)!,
            apiKey: apiKey,
            session: URLSession.shared,
            logger: ConsoleLogger()
        ))

        return .init(client: client)
    }()

    @MainActor private var envelopeRepo: EnvelopeRepository = {
        let storage = UserDefaults.standard
        return .init(storage: storage)
    }()

    var body: some View {
        let viewModel = BreakdownViewModel(props: .init(
            transactionRepo: transactionRepo,
            envelopeRepo: envelopeRepo,
            settings: settings
        ))

        BreakdownView(viewModel: viewModel)
            .environmentObject(transactionRepo)
            .environmentObject(envelopeRepo)
            .environmentObject(settings)
    }
}
