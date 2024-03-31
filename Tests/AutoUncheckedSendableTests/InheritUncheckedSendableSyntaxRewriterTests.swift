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

    func testNestedInheritSendable() {
        let source = """
        open class Obj {
            public class Obj2 {
                public class Obj3 {
                    public class Obj4 {}
                    public class Obj41 {}
                    public class Obj42 {}
                    public class Obj43 {}
                }
            }
            public class Obj5: Equatable, Codable {
                public class Obj6: Equatable,
                                  Codable {
                    public class Obj7<Value>: Collection where Value == Int {
                        typealias Element = Value
                    }
                }
            }
        }
        """
        let expectedOutput = """
        open class Obj: @unchecked Sendable {
            public class Obj2: @unchecked Sendable {
                public class Obj3: @unchecked Sendable {
                    public class Obj4: @unchecked Sendable {}
                    public class Obj41: @unchecked Sendable {}
                    public class Obj42: @unchecked Sendable {}
                    public class Obj43: @unchecked Sendable {}
                }
            }
            public class Obj5: Equatable, Codable, @unchecked Sendable {
                public class Obj6: Equatable,
                                  Codable,
                                  @unchecked Sendable {
                    public class Obj7<Value>: Collection, @unchecked Sendable where Value == Int {
                        typealias Element = Value
                    }
                }
            }
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testExceptForClasses() {
        let source = """
        open struct Obj {
            public enum Obj2 {
                public enum Obj3 {
                    public enum Obj4 {}
                    public enum Obj41 {}
                    public struct Obj42 {}
                    public struct Obj43 {}
                }
            }
            public enum Obj5: Equatable, Codable {
                public enum Obj6: Equatable,
                                  Codable {
                    public struct Obj7<Value>: Collection where Value == Int {
                        typealias Element = Value
                    }
                }
            }
        }
        """
        let expectedOutput = """
        open struct Obj {
            public enum Obj2 {
                public enum Obj3 {
                    public enum Obj4 {}
                    public enum Obj41 {}
                    public struct Obj42 {}
                    public struct Obj43 {}
                }
            }
            public enum Obj5: Equatable, Codable {
                public enum Obj6: Equatable,
                                  Codable {
                    public struct Obj7<Value>: Collection where Value == Int {
                        typealias Element = Value
                    }
                }
            }
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testNestStruct() {
        let source = """
        public struct Obj {
            public class Ojb2 {
                public struct Class21 {
                    public class Obj211 {}
                }
            }

            public struct Obj3 {
                public class Obj4 {}
            }
        }
        """

        let expectedOutput = """
        public struct Obj {
            public class Ojb2: @unchecked Sendable {
                public struct Class21 {
                    public class Obj211: @unchecked Sendable {}
                }
            }

            public struct Obj3 {
                public class Obj4: @unchecked Sendable {}
            }
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testNestEnum() {
        let source = """
        public enum Obj {
            public class Ojb2 {
                public enum Class21 {
                    public class Obj211 {}
                }
            }

            public enum Obj3 {
                public class Obj4 {}
            }
        }
        """

        let expectedOutput = """
        public enum Obj {
            public class Ojb2: @unchecked Sendable {
                public enum Class21 {
                    public class Obj211: @unchecked Sendable {}
                }
            }

            public enum Obj3 {
                public class Obj4: @unchecked Sendable {}
            }
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testNestActor() {
        let source = """
        public actor Obj {
            public class Ojb2 {
                public actor Class21 {
                    public class Obj211 {}
                }
            }

            public actor Obj3 {
                public class Obj4 {}
            }
        }
        """

        let expectedOutput = """
        public actor Obj {
            public class Ojb2: @unchecked Sendable {
                public actor Class21 {
                    public class Obj211: @unchecked Sendable {}
                }
            }

            public actor Obj3 {
                public class Obj4: @unchecked Sendable {}
            }
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }
}
