import SwiftUI

fileprivate struct Constants {
    static let lineWidth: CGFloat = 7
}

struct ProgressCircle<Content: View>: View {
    let value: Int
    let total: Int?
    let content: Content

    init(value: Int, total: Int? = nil, @ViewBuilder content: () -> Content) {
        self.value = value
        self.total = total
        self.content = content()
    }

    var body: some View {
        ZStack {
            backgroundCircle
            progressStroke
            content
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private var backgroundCircle: some View {
        Circle()
            .strokeBorder(lineWidth: Constants.lineWidth)
            .opacity(0.1)
            .foregroundColor(.primary)
    }

    private var progressStroke: some View {
        Group {
            if let progress = progress {
                Arc(endAngle: .degrees(progress))
                    .strokeBorder(style: StrokeStyle(
                        lineWidth: Constants.lineWidth,
                        lineCap: .round,
                        lineJoin: .round
                    ))
                    .foregroundColor(strokeColor)
            }
        }
    }

    private var progress: Double? {
        total.map { total in
            let progress = (Double(value) / Double(total)) * 360
            return min(progress, 360)
        }
    }

    private var strokeColor: Color {
        value > (total ?? 0) ? .pink : .green
    }
}
