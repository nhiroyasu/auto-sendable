import RewriterCore
import SwiftSyntax
import SwiftParser

public class AutoSendableRefactor {
    public init() {}
    
    public func exec(source: String) -> String {
        let syntax = Parser.parse(source: source)
        let rewriteSyntax = InheritTypeSyntaxRewriter(
            inheritType: "Sendable",
            delegate: AutoSendableRewriterDelegate(),
            viewMode: .all
        ).rewrite(syntax)
        let sourceSyntax = SourceFileSyntax(rewriteSyntax)!
        return sourceSyntax.description
    }
}
