import ScreenObject
import XCTest

class TestAppUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        app.launch()
        continueAfterFailure = false
    }

    func testIsLoadedReturnsTrueWhenScreenIsLoaded() throws {
        let screen = try HelloWorldScreen(app: app)
        XCTAssertTrue(screen.isLoaded)
    }

    func testIsLoadedReturnsTrueWhenScreenWithMultipleElementsIsLoaded() throws {
        let screen = try MultipleElementsScreen(app: app)
        XCTAssertTrue(screen.isLoaded)
    }

    func testIsLoadedReturnsFalseWhenScreenWithMultipleElementsNotLoaded() throws {
        let screen = try MissingSecondElementScreen(app: app)
        XCTAssertFalse(screen.isLoaded)
    }

    func testScreenInitThrowsWhenScreenIsNotLoaded() throws {
        do {
            _ = try MissingScreen(app: app)
            XCTFail("Expected `ScreenObject` `init` to throw, but it didn't")
        } catch {
            XCTAssertEqual(error as? ScreenObject.WaitForScreenError, .timedOut)
        }
    }

    func testScreenInitThrowsWhenScreenWithMultipleElementsIsNotLoaded() throws {
        do {
            _ = try MissingFirstElementScreen(app: app)
            XCTFail("Expected `ScreenObject` `init` to throw, but it didn't")
        } catch {
            XCTAssertEqual(error as? ScreenObject.WaitForScreenError, .timedOut)
        }
    }

    func testInitThrowsWhenGivenEmptyGettersArray() throws {
        do {
            _ = try ScreenObject(expectedElementGetters: [], app: app)
            XCTFail("Expected `ScreenObject` `init` to throw, but it didn't")
        } catch {
            XCTAssertEqual(error as? ScreenObject.InitError, .emptyExpectedElementGettersArray)
        }
    }
}

class HelloWorldScreen: ScreenObject {

    init(app: XCUIApplication) throws {
        try super.init(expectedElementGetter: { $0.staticTexts["Hello, world!"] }, app: app)
    }
}

/// A screen that requires multiple elements to be considered loaded.
///
/// Currently, this is the same screen as `HelloWorldScreen` in the app, but we might refine in the
/// future as we add more functionality.
class MultipleElementsScreen: ScreenObject {

    init(app: XCUIApplication) throws {
        try super.init(
            expectedElementGetters: [
                { $0.staticTexts["Hello, world!"] },
                { $0.staticTexts["Subtitle"] }
            ],
            app: app
        )
    }
}

/// A screen that doesn't exist. Use it to test the init failure behavior.
class MissingScreen: ScreenObject {

    init(app: XCUIApplication) throws {
        try super.init(
            expectedElementGetter: { $0.staticTexts["this screen does not exist"] },
            app: app,
            waitTimeout: 1 // We know the screen is not there, let's not wait for it for long
        )
    }
}

/// A screen where the first element does not exist. Use it to test the init failure
/// behavior.
class MissingFirstElementScreen: ScreenObject {

    init(app: XCUIApplication) throws {
        try super.init(
            expectedElementGetters: [
                { $0.staticTexts["this screen does not exist"] },
                { $0.staticTexts["Hello, world!"] }
            ],
            app: app
        )
    }
}

/// A screen where the first element exists, but the second does not. Use it to test the init passing,
/// and `isLoaded` failure behavior.
class MissingSecondElementScreen: ScreenObject {

    init(app: XCUIApplication) throws {
        try super.init(
            expectedElementGetters: [
                { $0.staticTexts["Hello, world!"] },
                { $0.staticTexts["this screen does not exist"] }
            ],
            app: app
        )
    }
}
