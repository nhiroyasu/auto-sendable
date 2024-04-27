import Foundation
import Util
import AutoUncheckedSendable

@main
class Main {
    static func main() {
        guard CommandLine.arguments.count > 1 else {
            print("⛔️ Please specify Swift files or directories to refactor as an argument.")
            return
        }
        let fileService = FileService()
        let refactor = AutoUncheckedSendableRefactor()

        let swiftFiles: Set<String> = CommandLine.arguments
            .dropFirst()
            .map { fileService.findSwiftFiles(in: $0) }
            .reduce(Set<String>(), { $0.union($1) })

        printColoredText("✅ \(swiftFiles.count) swift files were found.", colorCode: "32")

        for file in swiftFiles {
            do {
                let source = try String(contentsOfFile: file)
                let newSource = refactor.exec(source: source)
                try fileService.write(source: newSource, at: file)
                printColoredText("✅ Refactoring of \(file) has been completed.", colorCode: "32")
            } catch {
                print("⛔ Error:", error, "at: \(file)")
            }
        }
    }
}
