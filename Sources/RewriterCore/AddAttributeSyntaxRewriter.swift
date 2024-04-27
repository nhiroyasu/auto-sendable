import SwiftSyntax
import SwiftSyntaxBuilder

public class AddAttributeSyntaxRewriter: SyntaxRewriter {
    private let attributeName: String
    private let delegate: AddAttributeSyntaxRewriterDelegate

    public init(
        attributeName: String,
        delegate: AddAttributeSyntaxRewriterDelegate,
        viewMode: SyntaxTreeViewMode
    ) {
        self.attributeName = attributeName
        self.delegate = delegate
        super.init(viewMode: viewMode)
    }

    override public func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        guard delegate.decideContinuation(for: node) else {
            let nestRewriteNode = node.with(\.memberBlock, recursiveAddAttribute(for: node.memberBlock))
            return DeclSyntax(nestRewriteNode)
        }
        return DeclSyntax(add(node, attributeName: attributeName))
    }

    override public func visit(_ node: StructDeclSyntax) -> DeclSyntax {
        guard delegate.decideContinuation(for: node) else {
            let nestRewriteNode = node.with(\.memberBlock, recursiveAddAttribute(for: node.memberBlock))
            return DeclSyntax(nestRewriteNode)
        }
        return DeclSyntax(add(node, attributeName: attributeName))
    }

    override public func visit(_ node: EnumDeclSyntax) -> DeclSyntax {
        guard delegate.decideContinuation(for: node) else {
            let nestRewriteNode = node.with(\.memberBlock, recursiveAddAttribute(for: node.memberBlock))
            return DeclSyntax(nestRewriteNode)
        }
        return DeclSyntax(add(node, attributeName: attributeName))
    }

    override public func visit(_ node: ActorDeclSyntax) -> DeclSyntax {
        guard delegate.decideContinuation(for: node) else {
            let nestRewriteNode = node.with(\.memberBlock, recursiveAddAttribute(for: node.memberBlock))
            return DeclSyntax(nestRewriteNode)
        }
        return DeclSyntax(add(node, attributeName: attributeName))
    }

    override public func visit(_ node: ProtocolDeclSyntax) -> DeclSyntax {
        guard delegate.decideContinuation(for: node) else {
            let nestRewriteNode = node.with(\.memberBlock, recursiveAddAttribute(for: node.memberBlock))
            return DeclSyntax(nestRewriteNode)
        }
        return DeclSyntax(add(node, attributeName: attributeName))
    }

    override public func visit(_ node: FunctionDeclSyntax) -> DeclSyntax {
        guard delegate.decideContinuation(for: node) else {
            return DeclSyntax(node)
        }
        return DeclSyntax(add(node, attributeName: attributeName))
    }

    // MARK: - internal

    private func recursiveAddAttribute(for memberBlockSyntax: MemberBlockSyntax) -> MemberBlockSyntax {
        let newMemberBlockSyntax = AddAttributeSyntaxRewriter(
            attributeName: attributeName,
            delegate: delegate,
            viewMode: .all
        ).rewrite(memberBlockSyntax)
        return MemberBlockSyntax(newMemberBlockSyntax)!
    }

    private func isNotContainAttribute(
        _ attributes: AttributeListSyntax,
        attributeName: String
    ) -> Bool {
        !attributes.contains(where: {
            $0.as(AttributeSyntax.self)?.attributeName.as(IdentifierTypeSyntax.self)?.name.text == attributeName
        })
    }

    private func add(_ decl: ClassDeclSyntax, attributeName: String) -> ClassDeclSyntax {
        let nestRewriteNode = decl.with(\.memberBlock, recursiveAddAttribute(for: decl.memberBlock))
        // NOTE: Please do not use `node` from this point on. Use to `nestRewriteNode`

        guard isNotContainAttribute(nestRewriteNode.attributes, attributeName: attributeName) else {
            return nestRewriteNode
        }

        let trimmedTriviaDecl = nestRewriteNode.with(\.leadingTrivia, [])
        let newAttribute = factoryAttributeSyntax(attributeName: attributeName, leadingTrivia: nestRewriteNode.leadingTrivia)
        let newDecl = trimmedTriviaDecl.with(
            \.attributes,
             addAttribute(trimmedTriviaDecl.attributes, attribute: newAttribute)
        )
        return newDecl
    }

    private func add(_ decl: StructDeclSyntax, attributeName: String) -> StructDeclSyntax {
        let nestRewriteNode = decl.with(\.memberBlock, recursiveAddAttribute(for: decl.memberBlock))
        // NOTE: Please do not use `node` from this point on. Use to `nestRewriteNode`

        guard isNotContainAttribute(nestRewriteNode.attributes, attributeName: attributeName) else {
            return nestRewriteNode
        }

        let trimmedTriviaDecl = nestRewriteNode.with(\.leadingTrivia, [])
        let newAttribute = factoryAttributeSyntax(attributeName: attributeName, leadingTrivia: nestRewriteNode.leadingTrivia)
        let newDecl = trimmedTriviaDecl.with(
            \.attributes,
             addAttribute(trimmedTriviaDecl.attributes, attribute: newAttribute)
        )
        return newDecl
    }

    private func add(_ decl: EnumDeclSyntax, attributeName: String) -> EnumDeclSyntax {
        let nestRewriteNode = decl.with(\.memberBlock, recursiveAddAttribute(for: decl.memberBlock))
        // NOTE: Please do not use `node` from this point on. Use to `nestRewriteNode`

        guard isNotContainAttribute(nestRewriteNode.attributes, attributeName: attributeName) else {
            return nestRewriteNode
        }

        let trimmedTriviaDecl = nestRewriteNode.with(\.leadingTrivia, [])
        let newAttribute = factoryAttributeSyntax(attributeName: attributeName, leadingTrivia: nestRewriteNode.leadingTrivia)
        let newDecl = trimmedTriviaDecl.with(
            \.attributes,
             addAttribute(trimmedTriviaDecl.attributes, attribute: newAttribute)
        )
        return newDecl
    }

    private func add(_ decl: ProtocolDeclSyntax, attributeName: String) -> ProtocolDeclSyntax {
        let nestRewriteNode = decl.with(\.memberBlock, recursiveAddAttribute(for: decl.memberBlock))
        // NOTE: Please do not use `node` from this point on. Use to `nestRewriteNode`

        guard isNotContainAttribute(nestRewriteNode.attributes, attributeName: attributeName) else {
            return nestRewriteNode
        }

        let trimmedTriviaDecl = nestRewriteNode.with(\.leadingTrivia, [])
        let newAttribute = factoryAttributeSyntax(attributeName: attributeName, leadingTrivia: nestRewriteNode.leadingTrivia)
        let newDecl = trimmedTriviaDecl.with(
            \.attributes,
             addAttribute(trimmedTriviaDecl.attributes, attribute: newAttribute)
        )
        return newDecl
    }

    private func add(_ decl: ActorDeclSyntax, attributeName: String) -> ActorDeclSyntax {
        let nestRewriteNode = decl.with(\.memberBlock, recursiveAddAttribute(for: decl.memberBlock))
        // NOTE: Please do not use `node` from this point on. Use to `nestRewriteNode`

        guard isNotContainAttribute(nestRewriteNode.attributes, attributeName: attributeName) else {
            return nestRewriteNode
        }

        let trimmedTriviaDecl = nestRewriteNode.with(\.leadingTrivia, [])
        let newAttribute = factoryAttributeSyntax(attributeName: attributeName, leadingTrivia: nestRewriteNode.leadingTrivia)
        let newDecl = trimmedTriviaDecl.with(
            \.attributes,
             addAttribute(trimmedTriviaDecl.attributes, attribute: newAttribute)
        )
        return newDecl
    }

    private func add(_ decl: FunctionDeclSyntax, attributeName: String) -> FunctionDeclSyntax {
        guard isNotContainAttribute(decl.attributes, attributeName: attributeName) else {
            return decl
        }

        let trimmedTriviaDecl = decl.with(\.leadingTrivia, [])
        let newAttribute = factoryAttributeSyntax(attributeName: attributeName, leadingTrivia: decl.leadingTrivia)
        let newDecl = trimmedTriviaDecl.with(
            \.attributes,
             addAttribute(trimmedTriviaDecl.attributes, attribute: newAttribute)
        )
        return newDecl
    }

    private func addAttribute(
        _ attributes: AttributeListSyntax,
        attribute: AttributeSyntax
    ) -> AttributeListSyntax {
        let newAttribute = AttributeListSyntax.Element.attribute(attribute)
        return AttributeListBuilder.buildFinalResult(
            AttributeListBuilder.buildBlock([newAttribute] + attributes)
        )
    }

    private func factoryAttributeSyntax(attributeName: String, leadingTrivia: Trivia) -> AttributeSyntax {
        AttributeSyntax(
            leadingTrivia: leadingTrivia,
            atSign: .atSignToken(),
            attributeName: IdentifierTypeSyntax(
                name: .identifier(attributeName)
            ),
            trailingTrivia: [.spaces(1)]
        )
    }

}
