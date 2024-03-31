import SwiftSyntax
import SwiftSyntaxBuilder

class InheritSendableSyntaxRewriter: SyntaxRewriter {
    override func visit(_ node: StructDeclSyntax) -> DeclSyntax {
        return DeclSyntax(inheritSendable(node))
    }

    override func visit(_ node: EnumDeclSyntax) -> DeclSyntax {
        return DeclSyntax(inheritSendable(node))
    }

    override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        return DeclSyntax(checkNestDecl(node))
    }

    override func visit(_ node: ActorDeclSyntax) -> DeclSyntax {
        return DeclSyntax(checkNestDecl(node))
    }

    // MARK: - internal

    private func inheritSendable(_ decl: StructDeclSyntax) -> StructDeclSyntax {
        let nestSendableDecl = decl.with(\.memberBlock, recursiveInheritSendable(for: decl.memberBlock))
        // NOTE: Please do not use `decl` from this point on. Use to `nestSendableDecl`

        guard isPublicStruct(nestSendableDecl) else {
            return nestSendableDecl
        }
        guard isNotInheritedSendable(nestSendableDecl) else {
            return nestSendableDecl
        }

        if let inheritanceClause = nestSendableDecl.inheritanceClause {
            let newInheritanceClause = addSendableToInheritanceClause(
                currentInheritanceClause: inheritanceClause,
                sendableSyntax: factorySendableSyntax(previousSyntax: inheritanceClause.inheritedTypes.last)
            )
            let newSyntax = nestSendableDecl
                .with(\.inheritanceClause, newInheritanceClause)
            return newSyntax
        } else {
            let newInheritanceClause = factoryInheritanceClause(
                with: factorySendableSyntax(previousSyntax: nestSendableDecl.name)
            )
            let newSyntax = nestSendableDecl
                .with(\.inheritanceClause, newInheritanceClause)
                .with(\.name.trailingTrivia, [])
            return newSyntax
        }
    }

    private func inheritSendable(_ decl: EnumDeclSyntax) -> EnumDeclSyntax {
        let nestSendableDecl = decl.with(\.memberBlock, recursiveInheritSendable(for: decl.memberBlock))
        // NOTE: Please do not use `decl` from this point on. Use to `nestSendableDecl`

        guard isPublicEnum(nestSendableDecl) else {
            return nestSendableDecl
        }
        guard isNotInheritedSendable(nestSendableDecl) else {
            return nestSendableDecl
        }

        if let inheritanceClause = nestSendableDecl.inheritanceClause {
            let newInheritanceClause = addSendableToInheritanceClause(
                currentInheritanceClause: inheritanceClause,
                sendableSyntax: factorySendableSyntax(previousSyntax: inheritanceClause.inheritedTypes.last)
            )
            let newSyntax = nestSendableDecl
                .with(\.inheritanceClause, newInheritanceClause)
            return newSyntax
        } else {
            let newInheritanceClause = factoryInheritanceClause(
                with: factorySendableSyntax(previousSyntax: nestSendableDecl.name)
            )
            let newSyntax = nestSendableDecl
                .with(\.inheritanceClause, newInheritanceClause)
                .with(\.name.trailingTrivia, [])
            return newSyntax
        }
    }

    private func checkNestDecl(_ decl: ClassDeclSyntax) -> ClassDeclSyntax {
        let nestSendableDecl = decl.with(\.memberBlock, recursiveInheritSendable(for: decl.memberBlock))
        // NOTE: Please do not use `decl` from this point on. Use to `nestSendableDecl`

        return nestSendableDecl
    }

    private func checkNestDecl(_ decl: ActorDeclSyntax) -> ActorDeclSyntax {
        let nestSendableDecl = decl.with(\.memberBlock, recursiveInheritSendable(for: decl.memberBlock))
        // NOTE: Please do not use `decl` from this point on. Use to `nestSendableDecl`

        return nestSendableDecl
    }

    private func recursiveInheritSendable(for memberBlockSyntax: MemberBlockSyntax) -> MemberBlockSyntax {
        let newMemberBlockSyntax = InheritSendableSyntaxRewriter(viewMode: .all).rewrite(memberBlockSyntax)
        return MemberBlockSyntax(newMemberBlockSyntax)!
    }

    private func isPublicStruct(_ decl: StructDeclSyntax) -> Bool {
        decl.modifiers.contains(where: { $0.name.tokenKind == .keyword(.public) })
    }

    private func isPublicEnum(_ decl: EnumDeclSyntax) -> Bool {
        decl.modifiers.contains(where: { $0.name.tokenKind == .keyword(.public) })
    }

    private func isNotInheritedSendable(_ decl: StructDeclSyntax) -> Bool {
        decl.inheritanceClause?.inheritedTypes.allSatisfy {
            $0.type.as(IdentifierTypeSyntax.self)?.name.text != "Sendable" &&
            $0.type.as(AttributedTypeSyntax.self)?.baseType.as(IdentifierTypeSyntax.self)?.name.text != "Sendable"
        } ?? true
    }

    private func isNotInheritedSendable(_ decl: EnumDeclSyntax) -> Bool {
        decl.inheritanceClause?.inheritedTypes.allSatisfy {
            $0.type.as(IdentifierTypeSyntax.self)?.name.text != "Sendable" &&
            $0.type.as(AttributedTypeSyntax.self)?.baseType.as(IdentifierTypeSyntax.self)?.name.text != "Sendable"
        } ?? true
    }

    private func addSendableToInheritanceClause(
        currentInheritanceClause inheritanceClause: InheritanceClauseSyntax,
        sendableSyntax: InheritedTypeSyntax
    ) -> InheritanceClauseSyntax {
        let prefixInheritedTypes = arrangeTriviaForSendable(currentInheritedTypes: inheritanceClause.inheritedTypes)
        let newInheritedTypes = InheritedTypeListBuilder.buildFinalResult(
            InheritedTypeListBuilder.buildBlock(prefixInheritedTypes + [sendableSyntax])
        )
        return InheritanceClauseSyntax(
            colon: inheritanceClause.colon,
            inheritedTypes: newInheritedTypes
        )
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

    private func arrangeTriviaForSendable(currentInheritedTypes inheritedTypes: InheritedTypeListSyntax) -> [InheritedTypeListSyntax.Element] {
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

    private func factorySendableSyntax(previousSyntax: SyntaxProtocol?) -> InheritedTypeSyntax {
        InheritedTypeSyntax(
            type: IdentifierTypeSyntax(
                name: .identifier(
                    "Sendable",
                    leadingTrivia: previousSyntax?.leadingTrivia ?? [],
                    trailingTrivia: previousSyntax?.trailingTrivia ?? []
                )
            )
        )
    }
}
