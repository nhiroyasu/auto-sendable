# auto-sendable
This is a refactoring tool that adds the Sendable protocol to structs and enums.

# Usage
Inherit `Sendable` for public structs and enums.
```sh
swift run auto-sendable <dir_path_or_file_path_1> <dir_path_or_file_path_2>  ...
```

Inherit `@unchecked Sendable` for classes.
```sh
swift run auto-unchecked-sendable <dir_path_or_file_path_1> <dir_path_or_file_path_2>  ...
```


# Example
## `auto-sendable` command
### Before
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

### After

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

## `auto-unchecked-sendable` command
### Before

```swift
open class Obj {
    public class Obj2 {
        public class Obj3 {
            public class Obj4 {}
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
```

### After

```swift
open class Obj: @unchecked Sendable {
    public class Obj2: @unchecked Sendable {
        public class Obj3: @unchecked Sendable {
            public class Obj4: @unchecked Sendable {}
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
```

# Warning
The `auto-sendable` command will add the Sendable protocol to structs and enums even if they cannot conform to Sendable (for example, if they contain a class that is not Sendable).  
As a result, it is not possible to completely avoid warnings from the compiler.

```swift
public struct Obj: Sendable {  // warning: Obj struct isn't able to conform to the Sendable protocol.
    var variable: Class
}

public class Class {
    var count: Int
}
```

In addition, regardless of whether it is safe to pass data in concurrency domains, the `auto-unchecked-sendable` command will make all classes inherit @unchecked Sendable.  
Please be cautious when using it.
