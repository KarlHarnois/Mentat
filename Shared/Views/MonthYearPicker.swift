import SwiftUI

struct MonthYearPicker: View {
    @Binding var monthYear: MonthYear

    var body: some View {
        HStack {
            monthPicker
        }
    }

    private var monthPicker: some View {
        Picker(selection: monthBinding) {
            ForEach(Month.allCases, id: \.self) { month in
                Text(month.shortName)
            }
        } label: {
            Text("Month")
        }
    }

    private var monthBinding: Binding<Month> {
        .init {
            monthYear.month
        } set: { month in
            monthYear = .init(month: month, year: monthYear.year)
        }
    }
}
