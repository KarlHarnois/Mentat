import SwiftUI

struct BreakdownView: View {
    @StateObject var viewModel: BreakdownViewModel
    @State private var isPresentingConfiguration = false

    var body: some View {
        NavigationView {
            List {
                Section {
                    ExpenseSummaryView(breakdown: viewModel.state.breakdown)
                        .listRowBackground(Color.clear)
                }

                if let breakdown = viewModel.state.breakdown {
                    Group {
                        Section(header: Text("Triage")) {
                            uncategorizedExpenses(breakdown: breakdown)
                        }

                        ForEach(breakdown.categories) { category in
                            section(for: category, breakdown: breakdown)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .alert($viewModel.state.error)
            .navigationBarItems(trailing: configureEnvelopeButton)
            .onLoad {
                viewModel.send(.refresh)
            }
        }
    }

    private func section(for category: Category, breakdown: CategoryBreakdownReport) -> some View {
        Section(header: HStack {
            Text(category.rawValue.capitalized)
            Spacer()
            formattedMoney(breakdown.totalPerCategory[category])
        }) {
            ForEach(breakdown.subcategoriesByCategory[category] ?? []) { subcategory in
                let transactions = breakdown.transactions.filter {
                    $0.subcategory == subcategory && $0.category == category
                }

                NavigationLink(destination: list(for: transactions)) {
                    HStack {
                        Text(subcategory.rawValue.capitalized)
                        Spacer()
                        formattedMoney(breakdown.totalPerSubcategory[category]?[subcategory])
                    }
                }
            }

            if let uncategorizedTotal = breakdown.uncategorizedTotalByCategory[category] {
                let transactions = breakdown.transactions.filter {
                    $0.subcategory == nil && $0.category == category
                }

                NavigationLink(destination: list(for: transactions)) {
                    HStack {
                        Text("Other")
                        Spacer()
                        formattedMoney(uncategorizedTotal)
                    }
                }
            }
        }
    }

    private func uncategorizedExpenses(breakdown: CategoryBreakdownReport) -> some View {
        Group {
            if breakdown.uncategorizedExpenseTotal > 0 {
                let transactions = breakdown.transactions.filter { $0.category == nil }

                NavigationLink(destination: list(for: transactions)) {
                    HStack {
                        Text("Uncategorized")
                        Spacer()
                        formattedMoney(breakdown.uncategorizedExpenseTotal)
                    }
                }
            }
        }
    }

    private func list(for transactions: [Transaction]) -> some View {
        List(transactions) { transaction in
            HStack {
                Text(transaction.description)
                Spacer()
                formattedMoney(transaction.centAmount)
            }
        }
    }

    private func formattedMoney(_ centAmount: Int?) -> some View {
        let formatter = MoneyFormatter()
        let string = formatter.string(centAmount: centAmount ?? 0)
        return Text(string)
    }

    private var configureEnvelopeButton: some View {
        Button {
            viewModel.send(.showSettings)
        } label: {
            Image(systemName: "slider.horizontal.3")
        }
        .popover(isPresented: $viewModel.state.isPresentingSettings) {
            SettingsScreen()
        }
    }
}
