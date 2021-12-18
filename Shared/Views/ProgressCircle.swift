import SwiftUI

fileprivate struct Constants {
    static let lineWidth: CGFloat = 10
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
                .stroke(lineWidth: Constants.lineWidth)
                .opacity(0.3)
                .foregroundColor(tint)

            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(
                    lineWidth: Constants.lineWidth,
                    lineCap: .round,
                    lineJoin: .round
                ))
                .foregroundColor(tint)
                .rotationEffect(Angle(degrees: 270.0))

            content
        }
        .frame(width: 100, height: 100)
    }

    private var progress: Float {
        Float(value) / Float(total)
    }

    private var tint: Color {
        value > total ? .red : .green
    }
}
