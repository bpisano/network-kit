import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct BodyMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let typeName = type.trimmedDescription
        return [
            try ExtensionDeclSyntax("extension \(raw: typeName): HttpBody {}")
        ]
    }
}
