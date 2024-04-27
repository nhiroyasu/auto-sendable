import SwiftSyntax

public protocol AddModifierSyntaxRewriterDelegate {
    func decideContinuation(for declSyntax: ClassDeclSyntax) -> Bool
    func decideContinuation(for declSyntax: StructDeclSyntax) -> Bool
    func decideContinuation(for declSyntax: EnumDeclSyntax) -> Bool
    func decideContinuation(for declSyntax: ActorDeclSyntax) -> Bool
    func decideContinuation(for declSyntax: ProtocolDeclSyntax) -> Bool
}
