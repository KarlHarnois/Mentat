import Combine

@MainActor final class BudgetSummaryViewModel: ObservableObject {
    @Published var state: State

    private let props: Props
    private var cancellables = Set<AnyCancellable>()

    struct Props {
        let transactionRepo: TransactionRepository
        let envelopeRepo: EnvelopeRepository
        let settings: Settings
    }

    enum Action {
        case refresh
        case present(CategoryTransactionSummary)
        case presentUncategorized
    }

    struct State {
        var monthYear: MonthYear
        var error: IdentifiableError?
        var summary: TransactionSummary?
        var envelopes: [Category: Envelope] = [:]
        var isPresentingMonthYearPicker = false
        var isPresentingSettings = false
        var presentedSummary: CategoryTransactionSummary?
        var isPresentingUncategorized = false
    }

    init(props: Props) {
        self.state = .init(monthYear: props.settings.monthYear)
        self.props = props

        props
            .envelopeRepo
            .$envelopes
            .sink { [weak self] envelopes in
                self?.state.envelopes = envelopes
            }
            .store(in: &cancellables)

        props
            .settings
            .$monthYear
            .removeDuplicates()
            .sink { [weak self] monthYear in
                self?.state.monthYear = monthYear
                self?.refreshTransactions()
            }
            .store(in: &cancellables)

        props
            .transactionRepo
            .$summaryByMonthYear
            .combineLatest(props.settings.$monthYear) { summary, monthYear in
                summary[monthYear]
            }
            .sink { [weak self] summary in
                self?.state.summary = summary
            }
            .store(in: &cancellables)
    }

    func send(_ action: Action) {
        switch action {
        case .refresh:
            refreshTransactions()
            refreshEnvelopes()

        case .present(let summary):
            state.presentedSummary = summary

        case .presentUncategorized:
            state.isPresentingUncategorized = true
        }
    }

    private func refreshTransactions() {
        Task {
            do {
                try await props.transactionRepo.fetchTransactions(monthYear: state.monthYear)
            } catch {
                self.state.error = error.identifiable
            }
        }
    }

    private func refreshEnvelopes() {
        Task {
            do {
                try await props.envelopeRepo.refreshEnvelopes()
            } catch {
                self.state.error = error.identifiable
            }
        }
    }
}
