import RewriterCore
import SwiftSyntax

class AddFinalModifierRewriterDelegate: AddModifierSyntaxRewriterDelegate {
    func decideContinuation(for declSyntax: ClassDeclSyntax) -> Bool {
        isInheritedSendable(declSyntax)
    }
    
    func decideContinuation(for declSyntax: StructDeclSyntax) -> Bool {
        false
    }
    
    func decideContinuation(for declSyntax: EnumDeclSyntax) -> Bool {
        false
    }
    
    func decideContinuation(for declSyntax: ActorDeclSyntax) -> Bool {
        false
    }
    
    func decideContinuation(for declSyntax: ProtocolDeclSyntax) -> Bool {
        false
    }
    
    // MARK: - internal

    private func isInheritedSendable(_ decl: ClassDeclSyntax) -> Bool {
        decl.inheritanceClause?.inheritedTypes.contains {
            $0.type.as(IdentifierTypeSyntax.self)?.name.text == "Sendable"
        } ?? false
    }
}
