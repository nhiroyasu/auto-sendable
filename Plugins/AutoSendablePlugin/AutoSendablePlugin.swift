import Foundation
import PackagePlugin

@main
struct AutoSendablePlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: try context.tool(named: "AutoSendableExec").path.string)
        process.arguments = arguments
        try process.run()
        process.waitUntilExit()
    }
}
