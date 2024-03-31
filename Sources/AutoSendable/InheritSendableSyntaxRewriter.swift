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

    private func isOpenOrPublicStruct(_ decl: StructDeclSyntax) -> Bool {
        decl.modifiers.contains(where: { $0.name.tokenKind == .keyword(.public) || $0.name.tokenKind == .keyword(.open) })
    }

    private func isOpenOrPublicEnum(_ decl: EnumDeclSyntax) -> Bool {
        decl.modifiers.contains(where: { $0.name.tokenKind == .keyword(.public) || $0.name.tokenKind == .keyword(.open) })
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

    private func inheritSendable(_ decl: StructDeclSyntax) -> StructDeclSyntax {
        let nestSendableDecl = decl.with(\.memberBlock.members, recursiveInheritSendable(for: decl.memberBlock.members))
        // NOTE: Please do not use `decl` from this point on. Use to `nestSendableDecl`

        guard isOpenOrPublicStruct(nestSendableDecl) else {
            return nestSendableDecl
        }
        guard isNotInheritedSendable(nestSendableDecl) else {
            return nestSendableDecl
        }

        if let inheritanceClause = nestSendableDecl.inheritanceClause {
            let suffixInheritedTypes = arrangeTriviaForSendable(currentInheritedTypes: inheritanceClause.inheritedTypes)
            let sendableType = factorySendableSyntax(forwardSyntax: inheritanceClause.inheritedTypes.last)
            let newInheritedTypes = InheritedTypeListBuilder.buildFinalResult(
                InheritedTypeListBuilder.buildBlock(suffixInheritedTypes + [sendableType])
            )
            let newSyntax = nestSendableDecl
                .with(\.inheritanceClause, InheritanceClauseSyntax(
                    colon: inheritanceClause.colon,
                    inheritedTypes: newInheritedTypes
                ))
            return newSyntax
        } else {
            let sendableType = factorySendableSyntax(forwardSyntax: nestSendableDecl.name)
            let newInheritedTypes = InheritedTypeListBuilder.buildFinalResult(
                InheritedTypeListBuilder.buildBlock([sendableType])
            )
            let newSyntax = nestSendableDecl
                .with(\.inheritanceClause, InheritanceClauseSyntax(
                    colon: .colonToken(trailingTrivia: [.spaces(1)]),
                    inheritedTypes: newInheritedTypes
                ))
                .with(\.name.trailingTrivia, [])
            return newSyntax
        }
    }

    private func inheritSendable(_ decl: EnumDeclSyntax) -> EnumDeclSyntax {
        let nestSendableDecl = decl.with(\.memberBlock.members, recursiveInheritSendable(for: decl.memberBlock.members))
        // NOTE: Please do not use `decl` from this point on. Use to `nestSendableDecl`

        guard isOpenOrPublicEnum(nestSendableDecl) else {
            return nestSendableDecl
        }
        guard isNotInheritedSendable(nestSendableDecl) else {
            return nestSendableDecl
        }

        if let inheritanceClause = nestSendableDecl.inheritanceClause {
            let suffixInheritedTypes = arrangeTriviaForSendable(currentInheritedTypes: inheritanceClause.inheritedTypes)
            let sendableType = factorySendableSyntax(forwardSyntax: inheritanceClause.inheritedTypes.last)
            let newInheritedTypes = InheritedTypeListBuilder.buildFinalResult(
                InheritedTypeListBuilder.buildBlock(suffixInheritedTypes + [sendableType])
            )
            let newSyntax = nestSendableDecl
                .with(\.inheritanceClause, InheritanceClauseSyntax(
                    colon: inheritanceClause.colon,
                    inheritedTypes: newInheritedTypes
                ))
            return newSyntax
        } else {
            let sendableType = factorySendableSyntax(forwardSyntax: nestSendableDecl.name)
            let newInheritedTypes = InheritedTypeListBuilder.buildFinalResult(
                InheritedTypeListBuilder.buildBlock([sendableType])
            )
            let newSyntax = nestSendableDecl
                .with(\.inheritanceClause, InheritanceClauseSyntax(
                    colon: .colonToken(trailingTrivia: [.spaces(1)]),
                    inheritedTypes: newInheritedTypes
                ))
                .with(\.name.trailingTrivia, [])
            return newSyntax
        }
    }

    private func checkNestDecl(_ decl: ClassDeclSyntax) -> ClassDeclSyntax {
        let nestSendableDecl = decl.with(\.memberBlock.members, recursiveInheritSendable(for: decl.memberBlock.members))
        // NOTE: Please do not use `decl` from this point on. Use to `nestSendableDecl`

        return nestSendableDecl
    }

    private func checkNestDecl(_ decl: ActorDeclSyntax) -> ActorDeclSyntax {
        let nestSendableDecl = decl.with(\.memberBlock.members, recursiveInheritSendable(for: decl.memberBlock.members))
        // NOTE: Please do not use `decl` from this point on. Use to `nestSendableDecl`

        return nestSendableDecl
    }

    private func recursiveInheritSendable(for memberBlockList: MemberBlockItemListSyntax) -> MemberBlockItemListSyntax {
        let nestSendableMembers = memberBlockList.map {
            if let structSyntax = $0.decl.as(StructDeclSyntax.self) {
                return MemberBlockItemListBuilder.buildExpression(inheritSendable(structSyntax))
            } else if let enumSyntax = $0.decl.as(EnumDeclSyntax.self) {
                return MemberBlockItemListBuilder.buildExpression(inheritSendable(enumSyntax))
            } else if let classSyntax = $0.decl.as(ClassDeclSyntax.self) {
                return MemberBlockItemListBuilder.buildExpression(checkNestDecl(classSyntax))
            } else if let actorSyntax = $0.decl.as(ActorDeclSyntax.self) {
                return MemberBlockItemListBuilder.buildExpression(checkNestDecl(actorSyntax))
            } else {
                return MemberBlockItemListBuilder.buildExpression($0)
            }
        }
        return MemberBlockItemListBuilder.buildFinalResult(
           MemberBlockItemListBuilder.buildArray(nestSendableMembers)
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

    private func factorySendableSyntax(forwardSyntax: SyntaxProtocol?) -> InheritedTypeSyntax {
        InheritedTypeSyntax(
            type: IdentifierTypeSyntax(
                name: .identifier(
                    "Sendable",
                    leadingTrivia: forwardSyntax?.leadingTrivia ?? [],
                    trailingTrivia: forwardSyntax?.trailingTrivia ?? []
                )
            )
        )
    }
}
