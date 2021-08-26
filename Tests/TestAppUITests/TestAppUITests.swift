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
}

final class HelloWorldScreen: ScreenObject {

    init(app: XCUIApplication = XCUIApplication()) throws {
        try super.init(expectedElementGetter: { $0.staticTexts["Hello, world!"] })
    }
}
