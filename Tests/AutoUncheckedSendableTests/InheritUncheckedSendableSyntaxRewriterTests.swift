@testable import AutoUncheckedSendable
import SwiftParser
import XCTest

class InheritUncheckedSendableSyntaxRewriterTests: XCTestCase {
    func testInheritedUncheckSendable() {
        let source = """
        public class Obj {
        }
        """

        let expectedOutput = """
        public class Obj: @unchecked Sendable {
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritedUncheckSendable2() {
        let source = """
        class Obj
        {
        }
        """

        let expectedOutput = """
        class Obj: @unchecked Sendable
        {
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritedUncheckSendable3() {
        let source = """
        class Obj: Decodable {
        }
        """

        let expectedOutput = """
        class Obj: Decodable, @unchecked Sendable {
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritedUncheckSendable4() {
        let source = """
        public class Obj:
            Decodable {
        }
        """

        let expectedOutput = """
        public class Obj:
            Decodable,
            @unchecked Sendable {
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritedUncheckSendable5() {
        let source = """
        public class Obj:
            Decodable,
            Encodable {
        }
        """

        let expectedOutput = """
        public class Obj:
            Decodable,
            Encodable,
            @unchecked Sendable {
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritedUncheckSendable6() {
        let source = """
        public class Obj: Decodable,
                          Encodable {
        }
        """

        let expectedOutput = """
        public class Obj: Decodable,
                          Encodable,
                          @unchecked Sendable {
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritedUncheckSendable7() {
        let source = """
        public class Obj11: Decodable
        {
        }
        """

        let expectedOutput = """
        public class Obj11: Decodable, @unchecked Sendable
        {
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritedUncheckSendable8() {
        let source = """
        public class Obj12:
            Decodable
        {
        }
        """

        let expectedOutput = """
        public class Obj12:
            Decodable,
            @unchecked Sendable
        {
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritedUncheckSendable9() {
        let source = """
        public class Obj13:
            Decodable,
            Encodable
        {
        }
        """

        let expectedOutput = """
        public class Obj13:
            Decodable,
            Encodable,
            @unchecked Sendable
        {
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritedUncheckSendable10() {
        let source = """
        public class Obj14: Decodable,
                            Encodable
        {
        }
        """

        let expectedOutput = """
        public class Obj14: Decodable,
                            Encodable,
                            @unchecked Sendable
        {
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testAlreadyInheritedSendable1() {
        let source = """
        public class Obj14: Sendable
        {
        }
        """

        let expectedOutput = """
        public class Obj14: Sendable
        {
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testAlreadyInheritedSendable2() {
        let source = """
        public class Obj14: @unchecked Sendable
        {
        }
        """

        let expectedOutput = """
        public class Obj14: @unchecked Sendable
        {
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testAlreadyInheritedSendable3() {
        let source = """
        public class Obj14:
            Decodable,
            Encodable,
            Sendable
        {
        }
        """

        let expectedOutput = """
        public class Obj14:
            Decodable,
            Encodable,
            Sendable
        {
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testAlreadyInheritedSendable4() {
        let source = """
        public class Obj14:
            Decodable,
            Encodable,
            @unchecked Sendable
        {
        }
        """

        let expectedOutput = """
        public class Obj14:
            Decodable,
            Encodable,
            @unchecked Sendable
        {
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }
}
