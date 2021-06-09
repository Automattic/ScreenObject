import XCTest

open class ScreenObject {

    enum UITestError: Error {
        case unableToLocateElement
    }

    private let app: XCUIApplication
    private let probeElementGetter: (XCUIApplication) -> XCUIElement
    public var expectedElement: XCUIElement { probeElementGetter(app) }
    private let waitTimeout: TimeInterval

    @available(*, deprecated, message: "Use init(probeElementGetter:, app:) instead")
    public init(element: XCUIElement, app: XCUIApplication = XCUIApplication(), waitTimeout: TimeInterval = 20) throws {
        self.app = app
        probeElementGetter = { _ in element }
        self.waitTimeout = 20
        try waitForScreen()
    }

    public init(
        probeElementGetter: @escaping (XCUIApplication) -> XCUIElement,
        app: XCUIApplication = XCUIApplication(),
        waitTimeout: TimeInterval = 20
    ) throws {
        self.app = app
        self.probeElementGetter = probeElementGetter
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
