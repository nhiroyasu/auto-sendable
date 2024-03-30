# auto-sendable
This is a refactoring tool that adds the Sendable protocol to structs and enums.

# Examples
## Before

```swift
open struct Obj {
    public struct Obj2 {
        public struct Obj3 {
            public struct Obj4 {}
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
```

## After

```swift
open struct Obj: Sendable {
    public struct Obj2: Sendable {
        public struct Obj3: Sendable {
            public struct Obj4: Sendable {}
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
```

# Warning
This tool will add the Sendable protocol to structs and enums even if they cannot conform to Sendable (for example, if they contain a class that is not Sendable).  
As a result, it is not possible to completely avoid warnings from the compiler.

```swift
public struct Obj: Sendable {  // warning: Obj struct isn't able to conform to the Sendable protocol.
    var variable: Class
}

public class Class {
    var count: Int
}
```
