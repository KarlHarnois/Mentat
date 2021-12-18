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
                    categoryView(for: summary)
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
            ExpenseSummaryView(summary: viewModel.state.summary)
                .listRowBackground(Color.clear)
        }
    }

    private func categoryView(for summary: TransactionSummary) -> some View {
        Group {
            ForEach(summary.categorySections) { section in
                NavigationLink {
                    // Link to category summary view
                } label: {
                    CategorySummaryProgressView(summary: section)
                        .padding(.vertical)
                }
            }
        }
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
