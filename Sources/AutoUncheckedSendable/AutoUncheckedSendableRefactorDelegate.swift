import RewriterCore
import SwiftSyntax

class AutoUncheckedSendableRefactorDelegate: InheritTypeSyntaxRewriterDelegate {
    func decideContinuation(for declSyntax: ClassDeclSyntax) -> Bool {
        true
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

    func decideContinuation(for declSyntax: ExtensionDeclSyntax) -> Bool {
        false
    }
}
