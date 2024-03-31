import SwiftSyntax
import SwiftParser

public class SwiftSendableRefactor {
    public init() {}
    
    public func exec(source: String) -> String {
        let syntax = Parser.parse(source: source)
        let rewriteSyntax = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(syntax)
        let sourceSyntax = SourceFileSyntax(rewriteSyntax)!
        return sourceSyntax.description
    }
}
