import Foundation

public extension String {
    func ensureTrailingSlash() -> String {
        if !self.hasSuffix("/") {
            return self + "/"
        }
        return self
    }
}
