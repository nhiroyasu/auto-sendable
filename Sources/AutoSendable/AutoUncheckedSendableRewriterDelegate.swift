import RewriterCore
import SwiftSyntax

class AutoUncheckedSendableRefactorDelegate: InheritTypeSyntaxRewriterDelegate {
    func decideContinuation(for declSyntax: ClassDeclSyntax) -> Bool {
        isContainVariables(declSyntax)
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

    // MARK: - internal

    private func isContainVariables(_ decl: ClassDeclSyntax) -> Bool {
        decl.memberBlock.members
            .contains(where: {
                // NOTE: var keyword and not computed property
                $0.decl.as(VariableDeclSyntax.self)?.bindingSpecifier.text == "var" &&
                $0.decl.as(VariableDeclSyntax.self)?.bindings.first?.accessorBlock == nil
            })
    }
}
