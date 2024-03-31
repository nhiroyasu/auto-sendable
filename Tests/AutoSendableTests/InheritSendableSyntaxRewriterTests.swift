@testable import AutoSendable
import SwiftParser
import Foundation
import XCTest

class InheritSendableSyntaxRewriterTests: XCTestCase {
    func testInheritSendable1() {
        let source = """
        public struct Obj {
            let name: String
        }
        """

        let expectedOutput = """
        public struct Obj: Sendable {
            let name: String
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritSendable2() {
        let source = """
        public struct Obj: Codable {
            let name: String
        }
        """

        let expectedOutput = """
        public struct Obj: Codable, Sendable {
            let name: String
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }


    func testInheritSendable3() {
        let source = """
        public struct Obj: Codable, Equatable {
            let name: String
        }
        """

        let expectedOutput = """
        public struct Obj: Codable, Equatable, Sendable {
            let name: String
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritSendable4() {
        let source = """
        public struct Obj: Codable,
                           Equatable {
            let name: String
        }
        """

        let expectedOutput = """
        public struct Obj: Codable,
                           Equatable,
                           Sendable {
            let name: String
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritSendable5() {
        let source = """
        public struct Obj<Value>: Collection where Value == Int {
            typealias Element = Value
        }
        """

        let expectedOutput = """
        public struct Obj<Value>: Collection, Sendable where Value == Int {
            typealias Element = Value
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritSendable6() {
        let source = """
        open struct Obj {
            typealias Element = Value
        }
        """

        let expectedOutput = """
        open struct Obj: Sendable {
            typealias Element = Value
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritSendable7() {
        let source = """
        public struct Obj:
            Codable,
            Equatable
        {
            let name: String
        }
        """

        let expectedOutput = """
        public struct Obj:
            Codable,
            Equatable,
            Sendable
        {
            let name: String
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritSendable8() {
        let source = """
        public struct Obj
        {
            let name: String
        }
        """

        let expectedOutput = """
        public struct Obj: Sendable
        {
            let name: String
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testNestedInheritSendable() {
        let source = """
        open struct Obj {
            public struct Obj2 {
                public struct Obj3 {
                    public struct Obj4 {}
                    public struct Obj41 {}
                    public struct Obj42 {}
                    public struct Obj43 {}
                }
            }
            public struct Obj5: Equatable, Codable {
                public struct Obj6: Equatable,
                                    Codable {
                    public struct Obj7<Value>: Collection where Value == Int {
                        typealias Element = Value
                    }
                }
            }
        }
        """
        let expectedOutput = """
        open struct Obj: Sendable {
            public struct Obj2: Sendable {
                public struct Obj3: Sendable {
                    public struct Obj4: Sendable {}
                    public struct Obj41: Sendable {}
                    public struct Obj42: Sendable {}
                    public struct Obj43: Sendable {}
                }
            }
            public struct Obj5: Equatable, Codable, Sendable {
                public struct Obj6: Equatable,
                                    Codable,
                                    Sendable {
                    public struct Obj7<Value>: Collection, Sendable where Value == Int {
                        typealias Element = Value
                    }
                }
            }
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testNestedInheritSendable2() {
        let source = """
        public struct Obj {
            public struct Ojb2: Sendable {
                public struct Ojb3: Sendable {}
            }
            public struct Ojb21: Sendable {}
        }
        """

        let expectedOutput = """
        public struct Obj: Sendable {
            public struct Ojb2: Sendable {
                public struct Ojb3: Sendable {}
            }
            public struct Ojb21: Sendable {}
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testNestedInheritSendable3() {
        let source = """
        public struct Obj: Sendable {
            public struct Ojb2 {
                public struct Ojb3: Sendable {}
            }
            public struct Ojb21 {}
        }
        """

        let expectedOutput = """
        public struct Obj: Sendable {
            public struct Ojb2: Sendable {
                public struct Ojb3: Sendable {}
            }
            public struct Ojb21: Sendable {}
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testNestedInheritSendableForEnum() {
        let source = """
        open enum Obj {
            public enum Obj2 {
                public enum Obj3 {
                    public enum Obj4 {}
                    public enum Obj41 {}
                    public enum Obj42 {}
                    public enum Obj43 {}
                }
            }
            public enum Obj5: Equatable, Codable {
                public enum Obj6: Equatable,
                                  Codable {
                    public enum Obj7<Value>: Collection where Value == Int {
                        typealias Element = Value
                    }
                }
            }
        }
        """
        let expectedOutput = """
        open enum Obj: Sendable {
            public enum Obj2: Sendable {
                public enum Obj3: Sendable {
                    public enum Obj4: Sendable {}
                    public enum Obj41: Sendable {}
                    public enum Obj42: Sendable {}
                    public enum Obj43: Sendable {}
                }
            }
            public enum Obj5: Equatable, Codable, Sendable {
                public enum Obj6: Equatable,
                                  Codable,
                                  Sendable {
                    public enum Obj7<Value>: Collection, Sendable where Value == Int {
                        typealias Element = Value
                    }
                }
            }
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testNestedInheritSendableForEnum2() {
        let source = """
        public enum Obj: Sendable {
            public enum Ojb2 {
                public enum Ojb3: Sendable {}
            }
            public enum Ojb21 {}
        }
        """

        let expectedOutput = """
        public enum Obj: Sendable {
            public enum Ojb2: Sendable {
                public enum Ojb3: Sendable {}
            }
            public enum Ojb21: Sendable {}
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }


    func testNestedInheritSendableForEnumAndStruct() {
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
        open struct Obj: Sendable {
            public enum Obj2: Sendable {
                public enum Obj3: Sendable {
                    public enum Obj4: Sendable {}
                    public enum Obj41: Sendable {}
                    public struct Obj42: Sendable {}
                    public struct Obj43: Sendable {}
                }
            }
            public enum Obj5: Equatable, Codable, Sendable {
                public enum Obj6: Equatable,
                                  Codable,
                                  Sendable {
                    public struct Obj7<Value>: Collection, Sendable where Value == Int {
                        typealias Element = Value
                    }
                }
            }
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testDontInheritSendable() {
        let source = """
        struct Obj {
            let name: String
        }
        """

        let expectedOutput = """
        struct Obj {
            let name: String
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testDontInheritSendable2() {
        let source = """
        struct Obj {
            struct Ojb2 {
                struct Ojb3 {}
            }
            struct Ojb21 {}
        }
        """

        let expectedOutput = """
        struct Obj {
            struct Ojb2 {
                struct Ojb3 {}
            }
            struct Ojb21 {}
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testAlreadyInheritSendable() {
        let source = """
        struct Obj: Sendable {
            let name: String
        }
        """

        let expectedOutput = """
        struct Obj: Sendable {
            let name: String
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testAlreadyInheritSendable2() {
        let source = """
        struct Obj: Sendable {
            struct Ojb2: Sendable {
                struct Ojb3: Sendable {}
            }
            struct Ojb21: Sendable {}
        }
        """

        let expectedOutput = """
        struct Obj: Sendable {
            struct Ojb2: Sendable {
                struct Ojb3: Sendable {}
            }
            struct Ojb21: Sendable {}
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }

    func testAlreadyInheritSendable3() {
        let source = """
        public struct Obj {
            public struct Ojb2: Sendable {
                public struct Ojb3: Sendable {}
            }
            public struct Ojb21: Sendable {}
        }
        """

        let expectedOutput = """
        public struct Obj: Sendable {
            public struct Ojb2: Sendable {
                public struct Ojb3: Sendable {}
            }
            public struct Ojb21: Sendable {}
        }
        """

        let sourceSyntax = Parser.parse(source: source)
        let result = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(sourceSyntax).description
        XCTAssertEqual(result, expectedOutput)
    }
}
