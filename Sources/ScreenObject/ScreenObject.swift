import XCTest

// Defined as `open` so consumers can create subclasses of this. Not that there's anything that
// would stop a consumer from instantiating a `ScreenObject` directly, but that wouldn't be very
// useful. The screen object pattern expect the object to expose APIs to interact with the screen
// and those are obviously specific to each screen, hence should be added by each subclass.
open class ScreenObject {

    /// The `XCUIApplication` instance this screen is part of. This is the value passed at
    /// initialization time.
    public let app: XCUIApplication

    /// The `XCUIElement` used to evaluate whether the screen is loaded at runtime.
    public let expectedElement: XCUIElement

    /// Whether the screen is loaded at runtime. Evaluated inspecting the `expectedElement`
    /// property.
    public var isLoaded: Bool { expectedElement.exists }

    private let waitTimeout: TimeInterval

    @available(*, deprecated, message: "Use init(expectedElementGetter:, app:) instead")
    public init(element: XCUIElement, app: XCUIApplication = XCUIApplication(), waitTimeout: TimeInterval = 20) throws {
        self.app = app
        expectedElement = element
        self.waitTimeout = waitTimeout
        try waitForScreen()
    }

    public init(
        expectedElementGetter: @escaping (XCUIApplication) -> XCUIElement,
        app: XCUIApplication = XCUIApplication(),
        waitTimeout: TimeInterval = 20
    ) throws {
        self.app = app
        expectedElement = expectedElementGetter(app)
        self.waitTimeout = waitTimeout
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
}
