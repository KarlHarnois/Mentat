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

                titleView

                if let summary = viewModel.state.summary {
                    categoryGrid(for: summary)
                        .listRowBackground(Color.clear)
                }
            }
            .listStyle(.insetGrouped)
            .alert($viewModel.state.error)
            .navigationBarItems(leading: monthYearButton,trailing: settingsButton)
            .onSwipeRight(perform: settings.goToPreviousMonth)
            .onSwipeLeft(perform: settings.goToNextMonth)
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

    private var titleView: some View {
        Section {
            BudgetSummaryTitleView(summary: viewModel.state.summary)
                .listRowBackground(Color.clear)
        }
    }

    private func categoryGrid(for summary: TransactionSummary) -> some View {
        let spacing: CGFloat = 20
        let items = [GridItem(spacing: spacing), GridItem(spacing: spacing)]

        return LazyVGrid(columns: items, spacing: spacing) {
            ForEach(summary.categorySections) { section in
                CategorySummaryProgressView(summary: section)
            }
            CategorySummaryProgressView(
                uncategorizedTransactions: summary.uncategorizedTransactions,
                total: summary.uncategorizedExpenseTotal
            )
        }
        .listRowInsets(.init())
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
