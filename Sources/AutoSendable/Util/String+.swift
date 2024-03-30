import Foundation

extension String {
    func ensureTrailingSlash() -> String {
        if !self.hasSuffix("/") {
            return self + "/"
        }
        return self
    }
}
