import Foundation
enum LaunchArgument: String {
    case launchUIApplication = "LAUNCH_UI_APPLICATION"
    case testMode = "TEST_MODE"

    var isPresent: Bool {
        ProcessInfo.processInfo.arguments.contains(rawValue)
    }
}
