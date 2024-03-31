import Foundation

public extension String {
    func ensureTrailingSlash() -> String {
        if !self.hasSuffix("/") {
            return self + "/"
        }
        return self
    }

    func contains(regex: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            return !results.isEmpty
        } catch let error {
            print("Invalid regex: \(error.localizedDescription)")
            return false
        }
    }
}
