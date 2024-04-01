import RewriterCore
import SwiftSyntax

class AutoSendableRewriterDelegate: InheritTypeSyntaxRewriterDelegate {
    func decideContinuation(for declSyntax: ClassDeclSyntax) -> Bool {
        false
    }

    func decideContinuation(for declSyntax: StructDeclSyntax) -> Bool {
        declSyntax.modifiers.contains(where: { $0.name.tokenKind == .keyword(.public) })
    }

    func decideContinuation(for declSyntax: EnumDeclSyntax) -> Bool {
        declSyntax.modifiers.contains(where: { $0.name.tokenKind == .keyword(.public) })
    }

    func decideContinuation(for declSyntax: ActorDeclSyntax) -> Bool {
        false
    }

    func decideContinuation(for declSyntax: ProtocolDeclSyntax) -> Bool {
        false
    }

    func decideContinuation(for declSyntax: ExtensionDeclSyntax) -> Bool {
        false
    }
}
