import XCTest

// Defined as `open` so consumers can create subclasses of this. Not that there's anything that
// would stop a consumer from instantiating a `ScreenObject` directly, but that wouldn't be very
// useful. The screen object pattern expect the object to expose APIs to interact with the screen
// and those are obviously specific to each screen, hence should be added by each subclass.
open class ScreenObject {

    /// The default time used when waiting.
    public static let defaultWaitTimeout: TimeInterval = 20

    public enum WaitForScreenError: Equatable, Error {
        case timedOut
    }

    /// The possible errors the initialization process can throw.
    public enum InitError: Equatable, Error {
        case emptyExpectedElementGettersArray
    }

    /// The `XCUIApplication` instance this screen is part of. This is the value passed at
    /// initialization time.
    public let app: XCUIApplication

    private let expectedElementGetters: [(XCUIApplication) -> XCUIElement]

    /// Whether the whole screen is loaded at runtime (all elements in `expectedElementGetters`).
    public var isLoaded: Bool {
        do {
            try waitForScreen()
        } catch {
            return false
        }

        // The execution gets here only if all elements were found,
        // hence the hardcoded return value
        return true
    }

    private let waitTimeout: TimeInterval

    public init(
        expectedElementGetters: [(XCUIApplication) -> XCUIElement],
        app: XCUIApplication = XCUIApplication(),
        waitTimeout: TimeInterval = defaultWaitTimeout
    ) throws {
        guard expectedElementGetters.isEmpty == false else {
            throw InitError.emptyExpectedElementGettersArray
        }

        self.app = app
        self.expectedElementGetters = expectedElementGetters
        self.waitTimeout = waitTimeout
        try waitForScreen(firstElementOnly: true)
    }

    // Notice that this is a designated initializer, too, so that subclasses can delegate to either
    // the single- and multiple-getter `init` version. If this had been a `convenience`, subclasses
    // would not have been able to call it with `super`.
    public init(
        expectedElementGetter: @escaping (XCUIApplication) -> XCUIElement,
        app: XCUIApplication = XCUIApplication(),
        waitTimeout: TimeInterval = defaultWaitTimeout
    ) throws {
        self.app = app
        self.expectedElementGetters = [expectedElementGetter]
        self.waitTimeout = waitTimeout
        try waitForScreen(firstElementOnly: true)
    }

    @discardableResult
    public func waitForScreen(firstElementOnly: Bool = false) throws -> Self {
        let testedGetters = firstElementOnly ? [expectedElementGetters.first!] : expectedElementGetters

        try XCTContext.runActivity(named: "Confirm screen \(self) is loaded") { (activity) in
            try testedGetters.forEach { getter in
                let result = waitFor(
                    element: getter(app),
                    predicate: "isEnabled == true",
                    timeout: self.waitTimeout
                )

                guard result == .completed else { throw WaitForScreenError.timedOut }
            }
        }
        return self
    }

    private func waitFor(
        element: XCUIElement,
        predicate: String,
        timeout: TimeInterval
    ) -> XCTWaiter.Result {
        XCTWaiter.wait(
            for: [
                XCTNSPredicateExpectation(
                    predicate: NSPredicate(format: predicate),
                    object: element
                )
            ],
            timeout: timeout
        )
    }
}
