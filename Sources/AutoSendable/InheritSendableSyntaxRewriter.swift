import SwiftSyntax
import SwiftSyntaxBuilder

class InheritSendableSyntaxRewriter: SyntaxRewriter {
    override func visit(_ node: StructDeclSyntax) -> DeclSyntax {
        return DeclSyntax(inheritSendable(node))
    }

    override func visit(_ node: EnumDeclSyntax) -> DeclSyntax {
        return DeclSyntax(inheritSendable(node))
    }

    // MARK: - internal

    private func isOpenOrPublicStruct(_ decl: StructDeclSyntax) -> Bool {
        decl.modifiers.contains(where: { $0.name.tokenKind == .keyword(.public) || $0.name.tokenKind == .keyword(.open) })
    }

    private func isOpenOrPublicEnum(_ decl: EnumDeclSyntax) -> Bool {
        decl.modifiers.contains(where: { $0.name.tokenKind == .keyword(.public) || $0.name.tokenKind == .keyword(.open) })
    }

    private func isNotInheritedSendable(_ decl: StructDeclSyntax) -> Bool {
        decl.inheritanceClause?.inheritedTypes.allSatisfy { $0.type.as(IdentifierTypeSyntax.self)?.name.text != "Sendable" } ?? true
    }

    private func isNotInheritedSendable(_ decl: EnumDeclSyntax) -> Bool {
        decl.inheritanceClause?.inheritedTypes.allSatisfy { $0.type.as(IdentifierTypeSyntax.self)?.name.text != "Sendable" } ?? true
    }

    private func inheritSendable(_ decl: StructDeclSyntax) -> StructDeclSyntax {
        let nestSendableMembers = decl.memberBlock.members.map {
            if let structSyntax = $0.decl.as(StructDeclSyntax.self) {
                return MemberBlockItemListBuilder.buildExpression(inheritSendable(structSyntax))
            } else if let enumSyntax = $0.decl.as(EnumDeclSyntax.self) {
                return MemberBlockItemListBuilder.buildExpression(inheritSendable(enumSyntax))
            } else {
                return MemberBlockItemListBuilder.buildExpression($0)
            }
        }
        let nestSendableDecl = decl.with(
            \.memberBlock.members,
             MemberBlockItemListBuilder.buildFinalResult(
                MemberBlockItemListBuilder.buildArray(nestSendableMembers)
             )
        )
        // NOTE: Please do not use decl from this point on. Use to `nestSendableDecl`

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
        let nestSendableMembers = decl.memberBlock.members.map {
            if let structSyntax = $0.decl.as(StructDeclSyntax.self) {
                return MemberBlockItemListBuilder.buildExpression(inheritSendable(structSyntax))
            } else if let enumSyntax = $0.decl.as(EnumDeclSyntax.self) {
                return MemberBlockItemListBuilder.buildExpression(inheritSendable(enumSyntax))
            } else {
                return MemberBlockItemListBuilder.buildExpression($0)
            }
        }
        let nestSendableDecl = decl.with(
            \.memberBlock.members,
             MemberBlockItemListBuilder.buildFinalResult(
                MemberBlockItemListBuilder.buildArray(nestSendableMembers)
             )
        )
        // NOTE: Please do not use decl from this point on. Use to `nestSendableDecl`

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

    private func arrangeTriviaForSendable(currentInheritedTypes inheritedTypes: InheritedTypeListSyntax) -> [InheritedTypeListSyntax.Element] {
        inheritedTypes.map { syntax in
            let forwardCommaTrailingTrivia = inheritedTypes.compactMap { $0.trailingComma }.first?.trailingTrivia
            if syntax == inheritedTypes.last {
                return syntax
                    .with(\.trailingComma, .commaToken(trailingTrivia: forwardCommaTrailingTrivia ?? [.spaces(1)]))
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
