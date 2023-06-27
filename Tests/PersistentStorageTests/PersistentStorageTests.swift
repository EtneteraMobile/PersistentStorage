import XCTest
@testable import PersistentStorage

final class PersistentStorageTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(PersistentStorage().text, "Hello, World!")
    }
}
