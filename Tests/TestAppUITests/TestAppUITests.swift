import ScreenObject
import XCTest

class TestAppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["Hello, world!"].exists)
        XCTAssertEqual(ScreenObject().testProp, "Hey there!")
    }
}
