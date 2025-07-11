//
//  ConnectMacro.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

public struct ConnectMacro: MemberMacro, ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard
            let argument = node.arguments?.as(LabeledExprListSyntax.self)?.first?.expression.as(
                StringLiteralExprSyntax.self),
            let path = argument.segments.first?.description.trimmingCharacters(
                in: .init(charactersIn: "\""))
        else {
            context.diagnose(
                .init(
                    node: declaration,
                    message: MacroExpansionErrorMessage(
                        "@Connect requires a string literal path argument")
                )
            )
            return []
        }

        let isPublic = declaration.modifiers.contains { modifier in
            modifier.name.text == "public"
        }

        let accessModifier = isPublic ? "public " : ""

        return [
            "\(accessModifier)let path: String = \"\(path)\"",
            "\(accessModifier)let method: HttpMethod = .connect",
        ].compactMap { DeclSyntax(stringLiteral: $0) }
    }

    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let extensionDecl = try ExtensionDeclSyntax("extension \(type.trimmed): HttpRequest {}")
        return [extensionDecl]
    }
}
