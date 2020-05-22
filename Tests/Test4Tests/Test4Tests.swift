import XCTest
@testable import Test4

final class Test4Tests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        // E-mail validate

        XCTAssertEqual(
            LoginValidator.validate(text: "sdf@sdf.ru"),
            .valid
        )

        XCTAssertEqual(
            LoginValidator.validate(text: "sdf@sdf.r"),
            .invalid([.emailError])
        )

        // Length validate

        XCTAssertEqual(
            LoginValidator.validate(text: "df"),
            .invalid([.minLengthError])
        )

        XCTAssertEqual(
            LoginValidator.validate(text: "1"),
            .invalid([.minLengthError, .startCharacterError])
        )

        XCTAssertEqual(
            LoginValidator.validate(text: "qwertyuiopasdfghjklzxcvbnmqweasdzxcrtyu"),
            .invalid([.maxLengthError])
        )

        // Composition validate

        XCTAssertEqual(
            LoginValidator.validate(text: "jfsdf$"),
            .invalid([.compositionError])
        )

        XCTAssertEqual(
            LoginValidator.validate(text: "jf#sdf"),
            .invalid([.compositionError])
        )

        // First character validate

        XCTAssertEqual(
            LoginValidator.validate(text: "-wer"),
            .invalid([.startCharacterError])
        )

        XCTAssertEqual(
            LoginValidator.validate(text: "1fsdf"),
            .invalid([.startCharacterError])
        )

        XCTAssertEqual(
            LoginValidator.validate(text: ".fsdf"),
            .invalid([.startCharacterError])
        )

        XCTAssertEqual(
            LoginValidator.validate(text: "jfsdf"),
            .valid
        )
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
