import RewriterCore
import SwiftSyntax
import SwiftParser

public class AutoUncheckedSendableRefactor {
    public init() {}

    public func exec(source: String) -> String {
        let syntax = Parser.parse(source: source)
        let rewriteSyntax = InheritTypeSyntaxRewriter(
            inheritType: "@unchecked Sendable",
            delegate: AutoUncheckedSendableRefactorDelegate(),
            viewMode: .all
        ).rewrite(syntax)
        let sourceSyntax = SourceFileSyntax(rewriteSyntax)!
        return sourceSyntax.description
    }
}
