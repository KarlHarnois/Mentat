import SwiftUI

struct MonthYearPicker: View {
    @Binding var monthYear: MonthYear

    var body: some View {
        Group {
            monthPicker
            yearPicker
        }
    }

    private var monthPicker: some View {
        Picker("Month", selection: monthBinding) {
            ForEach(Month.allCases, id: \.self) { month in
                Text(month.longName)
            }
        }
    }

    private var yearPicker: some View {
        Picker("Year", selection: yearBinding) {
            ForEach(2019...2030, id: \.self) { year in
                Text(String(year))
            }
        }
    }

    private var monthBinding: Binding<Month> {
        .init {
            monthYear.month
        } set: { month in
            monthYear = .init(month: month, year: monthYear.year)
        }
    }

    private var yearBinding: Binding<Int> {
        .init {
            monthYear.year
        } set: { year in
            monthYear = .init(month: monthYear.month, year: year)
        }
    }
}
