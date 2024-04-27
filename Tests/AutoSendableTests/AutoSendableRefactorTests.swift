@testable import AutoSendable
import XCTest

class AutoSendableRefactorTests: XCTestCase {
    private let subject = AutoSendableRefactor()

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

        let result = subject.exec(source: source)
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

        let result = subject.exec(source: source)
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

        let result = subject.exec(source: source)
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

        let result = subject.exec(source: source)
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

        let result = subject.exec(source: source)
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritSendable6() {
        let source = """
        public struct Obj {
            typealias Element = Value
        }
        """

        let expectedOutput = """
        public struct Obj: Sendable {
            typealias Element = Value
        }
        """

        let result = subject.exec(source: source)
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

        let result = subject.exec(source: source)
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

        let result = subject.exec(source: source)
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritSendable9() {
        let source = """
        public struct Obj:
            Codable
        {
            let name: String
        }
        """

        let expectedOutput = """
        public struct Obj:
            Codable,
            Sendable
        {
            let name: String
        }
        """

        let result = subject.exec(source: source)
        XCTAssertEqual(result, expectedOutput)
    }

    func testNestedInheritSendable() {
        let source = """
        public struct Obj {
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
        public struct Obj: Sendable {
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

        let result = subject.exec(source: source)
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

        let result = subject.exec(source: source)
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

        let result = subject.exec(source: source)
        XCTAssertEqual(result, expectedOutput)
    }

    func testNestedInheritSendableForEnum() {
        let source = """
        public enum Obj {
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
        public enum Obj: Sendable {
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

        let result = subject.exec(source: source)
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

        let result = subject.exec(source: source)
        XCTAssertEqual(result, expectedOutput)
    }


    func testNestedInheritSendableForEnumAndStruct() {
        let source = """
        public struct Obj {
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
        public struct Obj: Sendable {
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

        let result = subject.exec(source: source)
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

        let result = subject.exec(source: source)
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

        let result = subject.exec(source: source)
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

        let result = subject.exec(source: source)
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

        let result = subject.exec(source: source)
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

        let result = subject.exec(source: source)
        XCTAssertEqual(result, expectedOutput)
    }

    func testAlreadyInheritSendable4() {
        let source = """
        public struct Obj: @unchecked Sendable {
            public struct Ojb2: Sendable {}
        }
        """

        let expectedOutput = """
        public struct Obj: @unchecked Sendable {
            public struct Ojb2: Sendable {}
        }
        """

        let result = subject.exec(source: source)
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritSendableForClass() {
        let source = """
        public class Obj {
            public class Ojb2 {
                class Ojb3 {}
            }
            class Ojb21 {}
        }
        """

        let expectedOutput = """
        public final class Obj: Sendable {
            public final class Ojb2: Sendable {
                final class Ojb3: Sendable {}
            }
            final class Ojb21: Sendable {}
        }
        """

        let result = subject.exec(source: source)
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritSendableFoClassWithLet() {
        let source = """
        public class Obj {
            public let name: String
        }
        """

        let expectedOutput = """
        public final class Obj: Sendable {
            public let name: String
        }
        """

        let result = subject.exec(source: source)
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritSendableForClassWithComputedProperties() {
        let source = """
        public class Obj {
            public var name: String {
                return "name"
            }
        }
        """

        let expectedOutput = """
        public final class Obj: Sendable {
            public var name: String {
                return "name"
            }
        }
        """

        let result = subject.exec(source: source)
        XCTAssertEqual(result, expectedOutput)
    }

    func testDontInheritSendableForClassWithVariables() {
        let source = """
        public class Obj {
            public var name: String
            public let age: Int
        }
        """

        let expectedOutput = """
        public class Obj: @unchecked Sendable {
            public var name: String
            public let age: Int
        }
        """

        let result = subject.exec(source: source)
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritSendableForProtocol() {
        let source = """
        public protocol Obj {
            func test()
        }
        """

        let expectedOutput = """
        public protocol Obj: Sendable {
            func test()
        }
        """

        let result = subject.exec(source: source)
        XCTAssertEqual(result, expectedOutput)
    }

    func testInheritSendableInNestClass() {
        let source = """
        public class Obj {
            public struct Ojb2 {
                public class Class21 {
                    public struct Obj211 {}
                }
            }

            public class Obj3 {
                public struct Obj4 {}
            }
        }
        """

        let expectedOutput = """
        public final class Obj: Sendable {
            public struct Ojb2: Sendable {
                public final class Class21: Sendable {
                    public struct Obj211: Sendable {}
                }
            }

            public final class Obj3: Sendable {
                public struct Obj4: Sendable {}
            }
        }
        """

        let result = subject.exec(source: source)
        XCTAssertEqual(result, expectedOutput)
    }

    func testNestActor() {
        let source = """
        public actor Obj {
            public struct Ojb2 {
                public actor Actor21 {
                    public struct Obj211 {}
                }
            }

            public actor Obj3 {
                public struct Obj4 {}
            }
        }
        """

        let expectedOutput = """
        public actor Obj {
            public struct Ojb2: Sendable {
                public actor Actor21 {
                    public struct Obj211: Sendable {}
                }
            }

            public actor Obj3 {
                public struct Obj4: Sendable {}
            }
        }
        """

        let result = subject.exec(source: source)
        XCTAssertEqual(result, expectedOutput)
    }

    func testNestExtension() {
        let source = """
        public struct Obj {}

        public extension Obj {
            public struct Ojb2: Codable, Equatable {}
        }
        """

        let expectedOutput = """
        public struct Obj: Sendable {}

        public extension Obj {
            public struct Ojb2: Codable, Equatable, Sendable {}
        }
        """

        let result = subject.exec(source: source)
        XCTAssertEqual(result, expectedOutput)
    }


}
