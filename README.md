# auto-sendable
A refactoring tool that ensures protocols, structs, enums, and classes conform to the Sendable protocol.

# Summary
This tool modifies Swift code to conform to the `Sendable` protocol under the following conditions:

- All `protocol` types.
- `struct`  and `enum` types marked with the `public` modifier.
- `class` types that do not contain any `var` variables (the `final` modifier is also applied).

Additionally, the tool conforms types to `@unchecked Sendable` under the following condition:

- `class` types that contain `var` variables.


# Usage
## Swift Command
### Prepare
Clone this repository.
```sh
git clone https://github.com/nhiroyasu/auto-sendable.git
cd auto-sendable
```

### Execute
```sh
swift run auto-sendable <dir_path_or_file_path_1> <dir_path_or_file_path_2>  ...
```

# Example
## `auto-sendable`
### Before
```swift
public struct Struct {}
public enum Enum {}
public protocol Protocol {}
public class Class {}
public class VariablesClass {
    var variable: Int
}
```

### After
```swift
public struct Struct: Sendable {}
public enum Enum: Sendable {}
public protocol Protocol: Sendable {}
public final class Class: Sendable {}
public class VariablesClass: @unchecked Sendable {
    var variable: Int
}
```

# Warning
The `auto-sendable` command enforces conformance to the `Sendable` protocol for `protocol`, `structs`, `enums`, and `classes`, even when they might not naturally conform to `Sendable` (for example, if they contain stored properties that are not `Sendable` themselves).  
As a result, it is not possible to completely eliminate compiler warnings.

```swift
public struct Obj: Sendable {  // warning: Obj struct isn't able to conform to the Sendable protocol.
    var variable: Class
}

public class Class {
    var count: Int
}
```
