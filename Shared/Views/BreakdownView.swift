import SwiftUI

struct BreakdownView: View {
    @StateObject var viewModel: BreakdownViewModel

    var body: some View {
        NavigationView {
            List {
                expenseSummarySection

                if let breakdown = viewModel.state.breakdown {
                    sections(for: breakdown)
                }
            }
            .listStyle(.insetGrouped)
            .alert($viewModel.state.error)
            .navigationBarItems(trailing: settingsButton)
            .onLoad {
                viewModel.send(.refresh)
            }
        }
    }

    private var expenseSummarySection: some View {
        Section {
            ExpenseSummaryView(breakdown: viewModel.state.breakdown)
                .listRowBackground(Color.clear)
        }
    }

    private func sections(for breakdown: CategoryBreakdownReport) -> some View {
        Group {
            Section(header: Text("Triage")) {
                uncategorizedExpenses(breakdown: breakdown)
            }

            ForEach(breakdown.categories) { category in
                section(for: category, breakdown: breakdown)
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
                let title = subcategory.rawValue.capitalized
                let amount = breakdown.totalPerSubcategory[category]?[subcategory] ?? 0
                row(title: title, centAmount: amount, transactions: transactions)
            }

            if let uncategorizedTotal = breakdown.uncategorizedTotalByCategory[category] {
                let transactions = breakdown.transactions.filter {
                    $0.subcategory == nil && $0.category == category
                }

                row(title: "Other", centAmount: uncategorizedTotal, transactions: transactions)
            }
        }
    }

    private func uncategorizedExpenses(breakdown: CategoryBreakdownReport) -> some View {
        Group {
            if breakdown.uncategorizedExpenseTotal > 0 {
                let transactions = breakdown.transactions.filter { $0.category == nil }
                let amount = breakdown.uncategorizedExpenseTotal
                row(title: "Uncategorized", centAmount: amount, transactions: transactions)
            }
        }
    }

    private func row(title: String, centAmount: Int, transactions: [Transaction]) -> some View {
        NavigationLink(destination: list(for: transactions)) {
            HStack {
                Text(title)
                Spacer()
                formattedMoney(centAmount)
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

    private var settingsButton: some View {
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
