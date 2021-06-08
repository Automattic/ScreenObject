import ScreenObject
import XCTest

class TestAppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()

        let screen = try HelloWorldScreen()
        XCTAssertTrue(screen.isLoaded)
    }
}

final class HelloWorldScreen: ScreenObject {

    init(app: XCUIApplication = XCUIApplication()) throws {
        try super.init(element: app.staticTexts["Hello, world!"])
    }
}
