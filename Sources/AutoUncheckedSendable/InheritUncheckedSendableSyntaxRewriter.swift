import SwiftSyntax
import SwiftSyntaxBuilder

public class InheritUncheckedSendableSyntaxRewriter: SyntaxRewriter {
    public override init(viewMode: SyntaxTreeViewMode) {
        super.init(viewMode: viewMode)
    }
    
    override public func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        return DeclSyntax(inheritUncheckedSendable(node))
    }
    
    override public func visit(_ node: StructDeclSyntax) -> DeclSyntax {
        return DeclSyntax(checkNestDecl(node))
    }
    
    override public func visit(_ node: EnumDeclSyntax) -> DeclSyntax {
        return DeclSyntax(checkNestDecl(node))
    }

    override public func visit(_ node: ActorDeclSyntax) -> DeclSyntax {
        return DeclSyntax(checkNestDecl(node))
    }
    
    // MARK: - internal
    
    private func inheritUncheckedSendable(_ decl: ClassDeclSyntax) -> ClassDeclSyntax {
        let nestSendableDecl = decl.with(\.memberBlock, recursiveInheritUncheckedSendable(for: decl.memberBlock))
        // NOTE: Please do not use `decl` from this point on. Use to `nestSendableDecl`
        
        guard isNotInheritedSendable(nestSendableDecl) else {
            return nestSendableDecl
        }
        
        if let inheritanceClause = nestSendableDecl.inheritanceClause {
            let newInheritanceClause = addSendableToInheritanceClause(
                currentInheritanceClause: inheritanceClause,
                sendableSyntax: factoryUncheckedSendableSyntax(previousSyntax: inheritanceClause.inheritedTypes.last)
            )
            let newSyntax = nestSendableDecl
                .with(\.inheritanceClause, newInheritanceClause)
            return newSyntax
        } else {
            let newInheritanceClause = buildInheritanceClauseWithSendable(
                sendableSyntax: factoryUncheckedSendableSyntax(previousSyntax: nestSendableDecl.name)
            )
            let newSyntax = nestSendableDecl
                .with(\.inheritanceClause, newInheritanceClause)
                .with(\.name.trailingTrivia, [])
            return newSyntax
        }
    }
    
    private func checkNestDecl(_ decl: StructDeclSyntax) -> StructDeclSyntax {
        let nestSendableDecl = decl.with(\.memberBlock, recursiveInheritUncheckedSendable(for: decl.memberBlock))
        // NOTE: Please do not use `decl` from this point on. Use to `nestSendableDecl`
        
        return nestSendableDecl
    }
    
    private func checkNestDecl(_ decl: EnumDeclSyntax) -> EnumDeclSyntax {
        let nestSendableDecl = decl.with(\.memberBlock, recursiveInheritUncheckedSendable(for: decl.memberBlock))
        // NOTE: Please do not use `decl` from this point on. Use to `nestSendableDecl`
        
        return nestSendableDecl
    }

    private func checkNestDecl(_ decl: ActorDeclSyntax) -> ActorDeclSyntax {
        let nestSendableDecl = decl.with(\.memberBlock, recursiveInheritUncheckedSendable(for: decl.memberBlock))
        // NOTE: Please do not use `decl` from this point on. Use to `nestSendableDecl`
        
        return nestSendableDecl
    }
    
    private func recursiveInheritUncheckedSendable(for memberBlockSyntax: MemberBlockSyntax) -> MemberBlockSyntax {
        let newMemberBlockSyntax = InheritUncheckedSendableSyntaxRewriter(viewMode: .all).rewrite(memberBlockSyntax)
        return MemberBlockSyntax(newMemberBlockSyntax)!
    }

    private func isNotInheritedSendable(_ decl: ClassDeclSyntax) -> Bool {
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

    private func buildInheritanceClauseWithSendable(sendableSyntax: InheritedTypeSyntax) -> InheritanceClauseSyntax {
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

    private func factoryUncheckedSendableSyntax(previousSyntax: SyntaxProtocol?) -> InheritedTypeSyntax {
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
            leadingTrivia: previousSyntax?.leadingTrivia ?? [],
            type: attributedType,
            trailingTrivia: previousSyntax?.trailingTrivia ?? []
        )
    }
}
