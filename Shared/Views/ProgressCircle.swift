import SwiftUI

fileprivate struct Constants {
    static let lineWidth: CGFloat = 8
}

struct ProgressCircle<Content: View>: View {
    let value: Int
    let total: Int
    let content: Content

    init(value: Int, total: Int, @ViewBuilder content: () -> Content) {
        self.value = value
        self.total = total
        self.content = content()
    }

    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(lineWidth: Constants.lineWidth)
                .opacity(0.1)
                .foregroundColor(.primary)

            Arc(endAngle: .degrees(progress))
                .strokeBorder(style: StrokeStyle(
                    lineWidth: Constants.lineWidth,
                    lineCap: .round,
                    lineJoin: .round
                ))
                .foregroundColor(strokeColor)

            content
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private var progress: Double {
        (Double(value) / Double(total)) * 360
    }

    private var strokeColor: Color {
        value > total ? .red : .green
    }
}
