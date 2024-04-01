import SwiftSyntax
import SwiftSyntaxBuilder

public class InheritTypeSyntaxRewriter: SyntaxRewriter {
    private let inheritType: String
    private let delegate: InheritTypeSyntaxRewriterDelegate

    public init(
        inheritType: String,
        delegate: InheritTypeSyntaxRewriterDelegate,
        viewMode: SyntaxTreeViewMode
    ) {
        self.inheritType = inheritType
        self.delegate = delegate
        super.init(viewMode: viewMode)
    }

    public override func visit(_ node: StructDeclSyntax) -> DeclSyntax {
        guard delegate.decideContinuation(for: node) else {
            let nestRewriteNode = node.with(\.memberBlock, recursiveInheritType(for: node.memberBlock))
            return DeclSyntax(nestRewriteNode)
        }
        return DeclSyntax(inherit(node, type: TypeSyntax(stringLiteral: inheritType)))
    }

    public override func visit(_ node: EnumDeclSyntax) -> DeclSyntax {
        guard delegate.decideContinuation(for: node) else {
            let nestRewriteNode = node.with(\.memberBlock, recursiveInheritType(for: node.memberBlock))
            return DeclSyntax(nestRewriteNode)
        }
        return DeclSyntax(inherit(node, type: TypeSyntax(stringLiteral: inheritType)))
    }

    public override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        guard delegate.decideContinuation(for: node) else {
            let nestRewriteNode = node.with(\.memberBlock, recursiveInheritType(for: node.memberBlock))
            return DeclSyntax(nestRewriteNode)
        }
        return DeclSyntax(inherit(node, type: TypeSyntax(stringLiteral: inheritType)))
    }

    public override func visit(_ node: ActorDeclSyntax) -> DeclSyntax {
        guard delegate.decideContinuation(for: node) else {
            let nestRewriteNode = node.with(\.memberBlock, recursiveInheritType(for: node.memberBlock))
            return DeclSyntax(nestRewriteNode)
        }
        return DeclSyntax(inherit(node, type: TypeSyntax(stringLiteral: inheritType)))
    }

    public override func visit(_ node: ProtocolDeclSyntax) -> DeclSyntax {
        guard delegate.decideContinuation(for: node) else {
            let nestRewriteNode = node.with(\.memberBlock, recursiveInheritType(for: node.memberBlock))
            return DeclSyntax(nestRewriteNode)
        }
        return DeclSyntax(inherit(node, type: TypeSyntax(stringLiteral: inheritType)))
    }

    public override func visit(_ node: ExtensionDeclSyntax) -> DeclSyntax {
        guard delegate.decideContinuation(for: node) else {
            let nestRewriteNode = node.with(\.memberBlock, recursiveInheritType(for: node.memberBlock))
            return DeclSyntax(nestRewriteNode)
        }
        return DeclSyntax(inherit(node, type: TypeSyntax(stringLiteral: inheritType)))
    }

    // MARK: - internal

    private func inherit(_ decl: StructDeclSyntax, type: TypeSyntax) -> StructDeclSyntax {
        let nestRewriteNode = decl.with(\.memberBlock, recursiveInheritType(for: decl.memberBlock))
        // NOTE: Please do not use `decl` from this point on. Use to `nestRewriteNode`

        guard isNotInheritedType(nestRewriteNode.inheritanceClause, typeSyntax: type) else {
            return nestRewriteNode
        }

        if let inheritanceClause = nestRewriteNode.inheritanceClause {
            let newInheritanceClause = appendInheritType(
                to: inheritanceClause,
                sendableSyntax: factoryInheritTypeSyntax(previousSyntax: inheritanceClause.inheritedTypes.last)
            )
            let newSyntax = nestRewriteNode
                .with(\.inheritanceClause, newInheritanceClause)
            return newSyntax
        } else {
            let newInheritanceClause = factoryInheritanceClause(
                with: factoryInheritTypeSyntax(previousSyntax: nestRewriteNode.name)
            )
            let newSyntax = nestRewriteNode
                .with(\.inheritanceClause, newInheritanceClause)
                .with(\.name.trailingTrivia, [])
            return newSyntax
        }
    }

    private func inherit(_ decl: EnumDeclSyntax, type: TypeSyntax) -> EnumDeclSyntax {
        let nestRewriteNode = decl.with(\.memberBlock, recursiveInheritType(for: decl.memberBlock))
        // NOTE: Please do not use `decl` from this point on. Use to `nestRewriteNode`

        guard isNotInheritedType(nestRewriteNode.inheritanceClause, typeSyntax: type) else {
            return nestRewriteNode
        }

        if let inheritanceClause = nestRewriteNode.inheritanceClause {
            let newInheritanceClause = appendInheritType(
                to: inheritanceClause,
                sendableSyntax: factoryInheritTypeSyntax(previousSyntax: inheritanceClause.inheritedTypes.last)
            )
            let newSyntax = nestRewriteNode
                .with(\.inheritanceClause, newInheritanceClause)
            return newSyntax
        } else {
            let newInheritanceClause = factoryInheritanceClause(
                with: factoryInheritTypeSyntax(previousSyntax: nestRewriteNode.name)
            )
            let newSyntax = nestRewriteNode
                .with(\.inheritanceClause, newInheritanceClause)
                .with(\.name.trailingTrivia, [])
            return newSyntax
        }
    }

    private func inherit(_ decl: ClassDeclSyntax, type: TypeSyntax) -> ClassDeclSyntax {
        let nestRewriteNode = decl.with(\.memberBlock, recursiveInheritType(for: decl.memberBlock))
        // NOTE: Please do not use `decl` from this point on. Use to `nestRewriteNode`

        guard isNotInheritedType(nestRewriteNode.inheritanceClause, typeSyntax: type) else {
            return nestRewriteNode
        }

        if let inheritanceClause = nestRewriteNode.inheritanceClause {
            let newInheritanceClause = appendInheritType(
                to: inheritanceClause,
                sendableSyntax: factoryInheritTypeSyntax(previousSyntax: inheritanceClause.inheritedTypes.last)
            )
            let newSyntax = nestRewriteNode
                .with(\.inheritanceClause, newInheritanceClause)
            return newSyntax
        } else {
            let newInheritanceClause = factoryInheritanceClause(
                with: factoryInheritTypeSyntax(previousSyntax: nestRewriteNode.name)
            )
            let newSyntax = nestRewriteNode
                .with(\.inheritanceClause, newInheritanceClause)
                .with(\.name.trailingTrivia, [])
            return newSyntax
        }
    }

    private func inherit(_ decl: ActorDeclSyntax, type: TypeSyntax) -> ActorDeclSyntax {
        let nestRewriteNode = decl.with(\.memberBlock, recursiveInheritType(for: decl.memberBlock))
        // NOTE: Please do not use `decl` from this point on. Use to `nestRewriteNode`

        guard isNotInheritedType(nestRewriteNode.inheritanceClause, typeSyntax: type) else {
            return nestRewriteNode
        }

        if let inheritanceClause = nestRewriteNode.inheritanceClause {
            let newInheritanceClause = appendInheritType(
                to: inheritanceClause,
                sendableSyntax: factoryInheritTypeSyntax(previousSyntax: inheritanceClause.inheritedTypes.last)
            )
            let newSyntax = nestRewriteNode
                .with(\.inheritanceClause, newInheritanceClause)
            return newSyntax
        } else {
            let newInheritanceClause = factoryInheritanceClause(
                with: factoryInheritTypeSyntax(previousSyntax: nestRewriteNode.name)
            )
            let newSyntax = nestRewriteNode
                .with(\.inheritanceClause, newInheritanceClause)
                .with(\.name.trailingTrivia, [])
            return newSyntax
        }
    }

    private func inherit(_ decl: ProtocolDeclSyntax, type: TypeSyntax) -> ProtocolDeclSyntax {
        let nestRewriteNode = decl.with(\.memberBlock, recursiveInheritType(for: decl.memberBlock))
        // NOTE: Please do not use `decl` from this point on. Use to `nestRewriteNode`

        guard isNotInheritedType(nestRewriteNode.inheritanceClause, typeSyntax: type) else {
            return nestRewriteNode
        }

        if let inheritanceClause = nestRewriteNode.inheritanceClause {
            let newInheritanceClause = appendInheritType(
                to: inheritanceClause,
                sendableSyntax: factoryInheritTypeSyntax(previousSyntax: inheritanceClause.inheritedTypes.last)
            )
            let newSyntax = nestRewriteNode
                .with(\.inheritanceClause, newInheritanceClause)
            return newSyntax
        } else {
            let newInheritanceClause = factoryInheritanceClause(
                with: factoryInheritTypeSyntax(previousSyntax: nestRewriteNode.name)
            )
            let newSyntax = nestRewriteNode
                .with(\.inheritanceClause, newInheritanceClause)
                .with(\.name.trailingTrivia, [])
            return newSyntax
        }
    }

    private func inherit(_ decl: ExtensionDeclSyntax, type: TypeSyntax) -> ExtensionDeclSyntax {
        let nestRewriteNode = decl.with(\.memberBlock, recursiveInheritType(for: decl.memberBlock))
        // NOTE: Please do not use `decl` from this point on. Use to `nestRewriteNode`

        guard isNotInheritedType(nestRewriteNode.inheritanceClause, typeSyntax: type) else {
            return nestRewriteNode
        }

        if let inheritanceClause = nestRewriteNode.inheritanceClause {
            let newInheritanceClause = appendInheritType(
                to: inheritanceClause,
                sendableSyntax: factoryInheritTypeSyntax(previousSyntax: inheritanceClause.inheritedTypes.last)
            )
            let newSyntax = nestRewriteNode
                .with(\.inheritanceClause, newInheritanceClause)
            return newSyntax
        } else {
            let newInheritanceClause = factoryInheritanceClause(
                with: factoryInheritTypeSyntax(previousSyntax: nestRewriteNode.extendedType)
            )
            let newSyntax = nestRewriteNode
                .with(\.inheritanceClause, newInheritanceClause)
                .with(\.extendedType.trailingTrivia, [])
            return newSyntax
        }
    }

    private func recursiveInheritType(for memberBlockSyntax: MemberBlockSyntax) -> MemberBlockSyntax {
        let newMemberBlockSyntax = InheritTypeSyntaxRewriter(
            inheritType: inheritType,
            delegate: delegate,
            viewMode: .all
        ).rewrite(memberBlockSyntax)
        return MemberBlockSyntax(newMemberBlockSyntax)!
    }

    private func appendInheritType(
        to inheritanceClause: InheritanceClauseSyntax,
        sendableSyntax: InheritedTypeSyntax
    ) -> InheritanceClauseSyntax {
        let prefixInheritedTypes = arrangeTrailingTrivia(for: inheritanceClause.inheritedTypes)
        let newInheritedTypes = InheritedTypeListBuilder.buildFinalResult(
            InheritedTypeListBuilder.buildBlock(prefixInheritedTypes + [sendableSyntax])
        )
        return InheritanceClauseSyntax(
            colon: inheritanceClause.colon,
            inheritedTypes: newInheritedTypes
        )
    }

    private func arrangeTrailingTrivia(for inheritedTypes: InheritedTypeListSyntax) -> [InheritedTypeListSyntax.Element] {
        inheritedTypes.map { syntax in
            let previousTrailingTrivia = syntax.previousToken(viewMode: .all)?.trailingTrivia
            if syntax == inheritedTypes.last {
                return syntax
                    .with(\.trailingComma, .commaToken(trailingTrivia: previousTrailingTrivia ?? [.spaces(1)]))
                    .with(\.type.trailingTrivia, [])
            } else {
                return syntax
            }
        }
    }

    private func factoryInheritanceClause(with sendableSyntax: InheritedTypeSyntax) -> InheritanceClauseSyntax {
        let newInheritedTypes = InheritedTypeListBuilder.buildFinalResult(
            InheritedTypeListBuilder.buildBlock([sendableSyntax])
        )
        return InheritanceClauseSyntax(
            colon: .colonToken(trailingTrivia: [.spaces(1)]),
            inheritedTypes: newInheritedTypes
        )
    }

    private func factoryInheritTypeSyntax(previousSyntax: SyntaxProtocol?) -> InheritedTypeSyntax {
        InheritedTypeSyntax(
            leadingTrivia: previousSyntax?.leadingTrivia ?? [],
            type: TypeSyntax(stringLiteral: inheritType),
            trailingTrivia: previousSyntax?.trailingTrivia ?? []
        )
    }

    private func isNotInheritedType(_ inheritanceClause: InheritanceClauseSyntax?, typeSyntax: TypeSyntax) -> Bool {
        inheritanceClause?.inheritedTypes.allSatisfy {
            $0.type.as(IdentifierTypeSyntax.self)?.name.text != getInheritTypeName(typeSyntax: typeSyntax) &&
            $0.type.as(AttributedTypeSyntax.self)?.baseType.as(IdentifierTypeSyntax.self)?.name.text != getInheritTypeName(typeSyntax: typeSyntax)
        } ?? true
    }

    private func getInheritTypeName(typeSyntax: TypeSyntax) -> String {
        if let idType = typeSyntax.as(IdentifierTypeSyntax.self) {
            return idType.name.text
        } else if let idType = typeSyntax.as(AttributedTypeSyntax.self)?.baseType.as(IdentifierTypeSyntax.self) {
            return idType.name.text
        } else {
            return ""
        }
    }
}
