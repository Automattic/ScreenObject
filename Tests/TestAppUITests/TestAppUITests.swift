import ScreenObject
import XCTest

class TestAppUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        app.launch()
        continueAfterFailure = false
    }

    func testIsLoadedReturnsTrueWhenScreenIsLoaded() throws {
        let screen = try HelloWorldScreen()
        XCTAssertTrue(screen.isLoaded)
    }

    func testScreenInitThrowsWhenScreenIsNotLoaded() throws {
        do {
            _ = try MissingScreen(app: app)
            XCTFail("Expected `ScreenObject` `init` to throw, but it didn't")
        } catch {
            XCTAssertEqual(error as? ScreenObject.WaitForScreenError, .timedOut)
        }
    }
}

final class HelloWorldScreen: ScreenObject {

    init(app: XCUIApplication = XCUIApplication()) throws {
        try super.init(expectedElementGetter: { $0.staticTexts["Hello, world!"] })
    }
}

/// A screen that doesn't exist. Use it to test the init failure behavior.
class MissingScreen: ScreenObject {

    init(app: XCUIApplication) throws {
        try super.init(
            expectedElementGetter: { $0.staticTexts["this screen does not exist"] },
            app: app,
            waitTimeout: 1
        )
    }
}
