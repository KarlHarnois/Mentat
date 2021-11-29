import SwiftUI

@main
struct AppLauncher {
    static func main() throws {
        let isTestMode = LaunchArgument.testMode.isPresent
        let shouldLaunchApp = LaunchArgument.launchUIApplication.isPresent

        if isTestMode && !shouldLaunchApp {
            EmptyApp.main()
        } else {
            MentatApp.main()
        }
    }

    private struct EmptyApp: App {
        var body: some Scene {
            WindowGroup {
                EmptyView()
            }
        }
    }
}
