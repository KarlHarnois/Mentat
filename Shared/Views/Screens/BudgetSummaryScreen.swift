import SwiftUI

struct BudgetSummaryScreen: View {
    @StateObject var viewModel: BudgetSummaryViewModel
    @EnvironmentObject var settings: Settings

    var body: some View {
        NavigationView {
            List {
                if viewModel.state.isPresentingMonthYearPicker {
                    monthYearPicker
                }

                expenseSummarySection

                if let summary = viewModel.state.summary {
                    sections(for: summary)
                }
            }
            .listStyle(.insetGrouped)
            .alert($viewModel.state.error)
            .navigationBarItems(leading: monthYearButton,trailing: settingsButton)
            .onLoad {
                viewModel.send(.refresh)
            }
        }
    }

    private var monthYearPicker: some View {
        Section {
            MonthYearPicker(monthYear: $settings.monthYear)
        }
    }

    private var expenseSummarySection: some View {
        Section {
            ExpenseSummaryView(breakdown: viewModel.state.summary)
                .listRowBackground(Color.clear)
        }
    }

    private func sections(for summary: TransactionSummary) -> some View {
        Group {
            Section {
                uncategorizedExpenses(breakdown: summary)

                row(
                    title: "All Transactions",
                    centAmount: summary.expenseTotal,
                    transactions: summary.transactions
                )
            }

            ForEach(Category.allCases) { category in
                section(for: category, breakdown: summary)
            }
        }
    }

    private func section(for category: Category, breakdown: TransactionSummary) -> some View {
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

    private func uncategorizedExpenses(breakdown: TransactionSummary) -> some View {
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
        TransactionList(transactions: transactions)
    }

    private func formattedMoney(_ centAmount: Int?) -> some View {
        let formatter = MoneyFormatter()
        let string = formatter.string(centAmount: centAmount ?? 0)
        return Text(string)
    }

    private var monthYearButton: some View {
        Button {
            viewModel.state.isPresentingMonthYearPicker.toggle()
        } label: {
            Text(viewModel.state.monthYear.formatted(.short))
        }
    }

    private var settingsButton: some View {
        Button {
            viewModel.state.isPresentingSettings = true
        } label: {
            Image(systemName: "slider.horizontal.3")
        }
        .popover(isPresented: $viewModel.state.isPresentingSettings) {
            SettingsScreen()
        }
    }
}
