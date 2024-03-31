import SwiftSyntax
import SwiftParser

class SwiftUncheckedSendableRefactor {
    func exec(source: String) -> String {
        let syntax = Parser.parse(source: source)
        let rewriteSyntax = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(syntax)
        let sourceSyntax = SourceFileSyntax(rewriteSyntax)!
        return sourceSyntax.description
    }
}
