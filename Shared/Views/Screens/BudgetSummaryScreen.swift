import SwiftUI

struct BudgetSummaryScreen: View {
    @StateObject var viewModel: BudgetSummaryViewModel
    @EnvironmentObject var settings: Settings

    var body: some View {
        NavigationView {
            ZStack {
                list
                uncategorizedDetailsLink
            }
            .alert($viewModel.state.error)
            .navigationBarItems(leading: monthYearButton,trailing: settingsButton)
            .navigationTitle("")
            .onLoad {
                viewModel.send(.refresh)
            }
            .push($viewModel.state.presentedSummary) { summary in
                CategorySummaryScreen(summary: summary)
            }
        }
    }

    private var list: some View {
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
        .onSwipeRight(perform: settings.goToPreviousMonth)
        .onSwipeLeft(perform: settings.goToNextMonth)
    }

    private var uncategorizedDetailsLink: some View {
        NavigationLink(
            isActive: $viewModel.state.isPresentingUncategorized,
            destination: {
                let transactions = viewModel.state.summary?.uncategorizedTransactions ?? []
                CategorySummaryScreen(uncategorizedTransactions: transactions)
            },
            label: {}
        )
    }

    private var monthYearPicker: some View {
        Section {
            MonthYearPicker(monthYear: $settings.monthYear)
        }
    }

    private var titleView: some View {
        Section {
            BudgetSummaryTitleView(summary: viewModel.state.summary)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
        }
    }

    private func categoryGrid(for summary: TransactionSummary) -> some View {
        let spacing: CGFloat = 20
        let items = [GridItem(spacing: spacing), GridItem(spacing: spacing)]

        return LazyVGrid(columns: items, spacing: spacing) {
            ForEach(summary.categorySections) { section in
                CategorySummaryProgressView(summary: section).onTapGesture {
                    viewModel.send(.present(section))
                }
            }
            CategorySummaryProgressView(
                uncategorizedTransactions: summary.uncategorizedTransactions,
                total: summary.uncategorizedExpenseTotal
            )
            .onTapGesture {
                viewModel.send(.presentUncategorized)
            }
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
