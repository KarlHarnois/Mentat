import Combine

@MainActor final class BreakdownViewModel: ObservableObject {
    @Published var state = State()

    private let props: Props
    private var cancellables = Set<AnyCancellable>()

    struct Props {
        let transactionRepo: TransactionRepository
        let envelopeRepo: EnvelopeRepository
    }

    enum Action {
        case refresh
        case showSettings
    }

    struct State {
        var error: IdentifiableError?
        var breakdown: CategoryBreakdownReport?
        var envelopes: [Category: Envelope] = [:]
        var isPresentingSettings = false
    }

    init(props: Props) {
        self.props = props

        props
            .envelopeRepo
            .$envelopes
            .sink { [weak self] envelopes in
                self?.state.envelopes = envelopes
            }
            .store(in: &cancellables)

        props
            .transactionRepo
            .$categoryBreakdownByMonthYear
            .sink { [weak self] breakdowns in
                let key = MonthYear(month: .november, year: 2021)
                self?.state.breakdown = breakdowns[key]
            }
            .store(in: &cancellables)
    }

    func send(_ action: Action) {
        switch action {
        case .refresh:
            refreshTransactions()
            refreshEnvelopes()

        case .showSettings:
            state.isPresentingSettings = true
        }
    }

    private func refreshTransactions() {
        Task {
            do {
                try await props.transactionRepo.fetchTransactions(
                    month: .november,
                    year: 2021
                )
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
