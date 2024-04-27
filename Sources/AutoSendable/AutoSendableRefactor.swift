import RewriterCore
import SwiftSyntax
import SwiftParser

public class AutoSendableRefactor {
    public init() {}
    
    public func exec(source: String) -> String {
        let syntax = Parser.parse(source: source)
        let rewriteSyntax = rewrite(syntax)
        let sourceSyntax = SourceFileSyntax(rewriteSyntax)!
        return sourceSyntax.description
    }

    // MARK: - internal

    private func rewrite(_ syntax: SourceFileSyntax) -> Syntax {
        var variableSyntax: Syntax = Syntax(syntax)
        variableSyntax = InheritTypeSyntaxRewriter(
            inheritType: "@unchecked Sendable",
            delegate: AutoUncheckedSendableRefactorDelegate(),
            viewMode: .all
        ).rewrite(variableSyntax)
        variableSyntax = InheritTypeSyntaxRewriter(
            inheritType: "Sendable",
            delegate: AutoSendableRewriterDelegate(),
            viewMode: .all
        ).rewrite(variableSyntax)
        variableSyntax = AddModifierSyntaxRewriter(
            modifier: .final,
            delegate: AddFinalModifierRewriterDelegate(),
            viewMode: .all
        ).rewrite(variableSyntax)
        return variableSyntax
    }
}
