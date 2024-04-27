import SwiftSyntax

public protocol AddAttributeSyntaxRewriterDelegate {
    func decideContinuation(for declSyntax: ClassDeclSyntax) -> Bool
    func decideContinuation(for declSyntax: StructDeclSyntax) -> Bool
    func decideContinuation(for declSyntax: EnumDeclSyntax) -> Bool
    func decideContinuation(for declSyntax: ActorDeclSyntax) -> Bool
    func decideContinuation(for declSyntax: ProtocolDeclSyntax) -> Bool
    func decideContinuation(for declSyntax: FunctionDeclSyntax) -> Bool
}

public extension AddAttributeSyntaxRewriterDelegate {
    func decideContinuation(for declSyntax: ClassDeclSyntax) -> Bool { false }
    func decideContinuation(for declSyntax: StructDeclSyntax) -> Bool { false }
    func decideContinuation(for declSyntax: EnumDeclSyntax) -> Bool { false }
    func decideContinuation(for declSyntax: ActorDeclSyntax) -> Bool { false }
    func decideContinuation(for declSyntax: ProtocolDeclSyntax) -> Bool { false }
    func decideContinuation(for declSyntax: FunctionDeclSyntax) -> Bool { false }
}
