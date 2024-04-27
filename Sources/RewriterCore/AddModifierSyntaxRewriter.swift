import SwiftSyntax
import SwiftSyntaxBuilder

public class AddModifierSyntaxRewriter: SyntaxRewriter {
    private let modifier: Keyword
    private let delegate: AddModifierSyntaxRewriterDelegate
    public init(
        modifier: Keyword,
        delegate: AddModifierSyntaxRewriterDelegate,
        viewMode: SyntaxTreeViewMode
    ) {
        self.modifier = modifier
        self.delegate = delegate
        super.init(viewMode: viewMode)
    }
    
    override public func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        guard delegate.decideContinuation(for: node) else {
            let nestRewriteNode = node.with(
                \.memberBlock,
                 recursiveAddingModifier(for: node.memberBlock)
            )
            return DeclSyntax(nestRewriteNode)
        }
        let modifier = DeclModifierSyntax(
            leadingTrivia: node.classKeyword.leadingTrivia,
            name: .keyword(modifier),
            trailingTrivia: [.spaces(1)]
        )
        return DeclSyntax(add(node, modifier: modifier))
    }

    // MARK: - internal

    private func add(_ decl: ClassDeclSyntax, modifier: DeclModifierSyntax) -> ClassDeclSyntax {
        let nestRewriteNode = decl.with(\.memberBlock, recursiveAddingModifier(for: decl.memberBlock))
        // NOTE: Please do not use `node` from this point on. Use to `nestRewriteNode`

        guard isContainModifier(nestRewriteNode) else {
            return nestRewriteNode
        }

        let newClassDecl = addModifier(
            nestRewriteNode,
            modifier: modifier
        )
        return newClassDecl
    }

    private func recursiveAddingModifier(for memberBlockSyntax: MemberBlockSyntax) -> MemberBlockSyntax {
        let newMemberBlockSyntax = AddModifierSyntaxRewriter(
            modifier: modifier,
            delegate: delegate,
            viewMode: .all
        ).rewrite(memberBlockSyntax)
        return MemberBlockSyntax(newMemberBlockSyntax)!
    }

    private func isContainModifier(_ decl: ClassDeclSyntax) -> Bool {
        !decl.modifiers.contains(where: { $0.name.text == TokenSyntax.keyword(modifier).text })
    }

    private func addModifier(_ decl: ClassDeclSyntax, modifier: DeclModifierSyntax) -> ClassDeclSyntax {
        if decl.modifiers.isEmpty {
            let modifierSyntax = modifier
                        .with(\.leadingTrivia, decl.classKeyword.leadingTrivia)
                        .with(\.trailingTrivia, [.spaces(1)])
            let newDecl = decl
                .with(\.modifiers, [modifierSyntax])
                .with(\.classKeyword.leadingTrivia, [])
            return newDecl
        } else {
            let modifierSyntax = modifier.with(\.trailingTrivia, decl.modifiers.first!.trailingTrivia)
            let newDecl = decl
                .with(\.modifiers, decl.modifiers + [modifierSyntax])
            return newDecl
        }
    }
}
