import XCTest

open class ScreenObject {

    enum UITestError: Error {
        case unableToLocateElement
    }

    let app: XCUIApplication
    let expectedElement: XCUIElement
    let waitTimeout: TimeInterval

    public init(element: XCUIElement, app: XCUIApplication = XCUIApplication(), waitTimeout: TimeInterval = 20) throws {
        self.app = app
        expectedElement = element
        self.waitTimeout = 20
        try waitForScreen()
    }

    public init(
        probeElementGetter: (XCUIApplication) -> XCUIElement,
        app: XCUIApplication = XCUIApplication(),
        waitTimeout: TimeInterval = 20
    ) throws {
        self.app = app
        expectedElement = probeElementGetter(app)
        self.waitTimeout = 20
        try waitForScreen()
    }

    @discardableResult
    func waitForScreen() throws -> Self {
        XCTContext.runActivity(named: "Confirm screen \(self) is loaded") { (activity) in
            let result = waitFor(element: expectedElement, predicate: "isEnabled == true", timeout: 20)
            XCTAssert(result, "Screen \(self) is not loaded.")
        }
        return self
    }

    private func waitFor(element: XCUIElement, predicate: String, timeout: Int = 5) -> Bool {
        let elementPredicate = XCTNSPredicateExpectation(predicate: NSPredicate(format: predicate), object: element)
        let result = XCTWaiter.wait(for: [elementPredicate], timeout: TimeInterval(timeout))

        return result == .completed
    }

    public var isLoaded: Bool { expectedElement.exists }
}
