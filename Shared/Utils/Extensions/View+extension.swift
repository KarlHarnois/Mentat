import SwiftUI

extension View {
    func alert(_ error: Binding<IdentifiableError?>) -> some View {
        alert(item: error) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("Ok"))
            )
        }
    }

    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }

    func onSwipeRight(perform action: @escaping () -> Void) -> some View {
        modifier(SwipeGesture(side: .right, onGesture: action))
    }

    func onSwipeLeft(perform action: @escaping () -> Void) -> some View {
        modifier(SwipeGesture(side: .left, onGesture: action))
    }
}

struct ViewDidLoadModifier: ViewModifier {
    @State private var didLoad = false

    private let action: (() -> Void)?

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }
}


struct SwipeGesture: ViewModifier {
    let side: Side
    let onGesture: () -> Void

    enum Side {
        case left, right
    }

    struct Constants {
        static let distance: CGFloat = 20
    }

    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .simultaneousGesture(
                DragGesture(minimumDistance: Constants.distance, coordinateSpace: .local)
                    .onEnded { value in
                        switch side {
                        case .left:
                            if value.translation.width < Constants.distance {
                                onGesture()
                            }
                        case .right:
                            if value.translation.width > Constants.distance {
                                onGesture()
                            }
                        }
                    }
            )
    }
}
