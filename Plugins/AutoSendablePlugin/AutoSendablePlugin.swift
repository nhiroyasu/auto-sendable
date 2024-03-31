import Foundation
import PackagePlugin

@main
struct AutoSendablePlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: try context.tool(named: "AutoSendable").path.string)
        process.arguments = context.package.sourceModules.flatMap { $0.sourceFiles }.map { $0.path.string }
        try process.run()
        process.waitUntilExit()
    }
}
