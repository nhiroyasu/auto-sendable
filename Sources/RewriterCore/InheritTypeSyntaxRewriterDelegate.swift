import SwiftSyntax

public protocol InheritTypeSyntaxRewriterDelegate {
    func decideContinuation(for declSyntax: ClassDeclSyntax) -> Bool
    func decideContinuation(for declSyntax: StructDeclSyntax) -> Bool
    func decideContinuation(for declSyntax: EnumDeclSyntax) -> Bool
    func decideContinuation(for declSyntax: ActorDeclSyntax) -> Bool
    func decideContinuation(for declSyntax: ProtocolDeclSyntax) -> Bool
    func decideContinuation(for declSyntax: ExtensionDeclSyntax) -> Bool
}
