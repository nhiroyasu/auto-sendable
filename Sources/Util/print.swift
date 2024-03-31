public func printColoredText(
    _ text: String,
    colorCode: String
) {
    print("\u{001B}[\(colorCode)m\(text)\u{001B}[0m")
}
