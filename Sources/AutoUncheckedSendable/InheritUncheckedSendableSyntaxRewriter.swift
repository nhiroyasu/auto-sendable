import SwiftSyntax
import SwiftSyntaxBuilder

class InheritUncheckedSendableSyntaxRewriter: SyntaxRewriter {
    override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        return DeclSyntax(inheritUncheckedSendable(node))
    }

    // MARK: - internal

    private func inheritUncheckedSendable(_ decl: ClassDeclSyntax) -> ClassDeclSyntax {
        let nestSendableMembers = decl.memberBlock.members.map {
            if let classSyntax = $0.decl.as(ClassDeclSyntax.self) {
                return MemberBlockItemListBuilder.buildExpression(inheritUncheckedSendable(classSyntax))
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

        guard isNotInheritedSendable(nestSendableDecl) else {
            return nestSendableDecl
        }

        if let inheritanceClause = nestSendableDecl.inheritanceClause {
            let suffixInheritedTypes = arrangeTriviaForSendable(currentInheritedTypes: inheritanceClause.inheritedTypes)
            let sendableType = factoryUncheckedSendableSyntax(forwardSyntax: inheritanceClause.inheritedTypes.last)
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
            let sendableType = factoryUncheckedSendableSyntax(forwardSyntax: nestSendableDecl.name)
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

    private func isNotInheritedSendable(_ decl: ClassDeclSyntax) -> Bool {
        decl.inheritanceClause?.inheritedTypes.allSatisfy {
            $0.type.as(IdentifierTypeSyntax.self)?.name.text != "Sendable" &&
            $0.type.as(AttributedTypeSyntax.self)?.baseType.as(IdentifierTypeSyntax.self)?.name.text != "Sendable"
        } ?? true
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

    private func factoryUncheckedSendableSyntax(forwardSyntax: SyntaxProtocol?) -> InheritedTypeSyntax {
        let attributes = AttributeListBuilder.buildFinalResult(
            AttributeListBuilder.buildBlock(
                AttributeListBuilder.buildExpression(
                    AttributeSyntax(
                        atSign: .atSignToken(),
                        attributeName: IdentifierTypeSyntax(
                            name: .identifier("unchecked"),
                            trailingTrivia: [.spaces(1)]
                        )
                    )
                )
            )
        )
        let baseType = IdentifierTypeSyntax(
            name: .identifier("Sendable")
        )
        let attributedType = AttributedTypeSyntax(
            leadingTrivia: nil,
            specifiers: [],
            attributes: attributes,
            baseType: baseType,
            trailingTrivia: nil
        )
        return InheritedTypeSyntax(
            leadingTrivia: forwardSyntax?.leadingTrivia ?? [],
            type: attributedType,
            trailingTrivia: forwardSyntax?.trailingTrivia ?? []
        )
    }
}
