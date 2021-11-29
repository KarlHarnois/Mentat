import XCTest

class AppTestCase: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["LAUNCH_UI_APPLICATION"]
        app.launch()
    }
}
