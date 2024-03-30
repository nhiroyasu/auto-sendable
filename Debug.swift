class Person {
    var first: Int
    var name: String = ""
    var displayName: String {
        return ""
    }
    var age: Int {
        get {
            self
        }
        set {
            self = newValue
        }
    }
    func hello() {}
}
