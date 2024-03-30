import Foundation
import SwiftSyntax
import SwiftParser

class SwiftSendableRefactor {
    func exec(source: String) -> String {
        let syntax = Parser.parse(source: source)
        let rewriteSyntax = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(syntax)
        let sourceSyntax = SourceFileSyntax(rewriteSyntax)!
        return sourceSyntax.description
    }
}
