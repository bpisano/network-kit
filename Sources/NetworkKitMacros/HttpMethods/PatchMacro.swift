//
//  PatchMacro.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

public struct PatchMacro: MemberMacro, ExtensionMacro {

    // MARK: - MemberMacro Implementation

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        // Extract the path argument from the @Patch macro
        guard let path = extractPathArgument(from: node, context: context, declaration: declaration)
        else {
            return []
        }

        // Determine access modifier based on the declaration
        let accessModifier = determineAccessModifier(from: declaration)

        // Generate the required declarations
        return generateDeclarations(
            path: path,
            accessModifier: accessModifier,
            method: "patch"
        )
    }

    // MARK: - ExtensionMacro Implementation

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

    // MARK: - Helper Methods

    /// Extracts the path argument from the @Patch macro attribute
    private static func extractPathArgument(
        from node: AttributeSyntax,
        context: some MacroExpansionContext,
        declaration: some DeclGroupSyntax
    ) -> String? {
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
                        "@Patch requires a string literal path argument")
                )
            )
            return nil
        }
        return path
    }

    /// Determines the access modifier based on the declaration modifiers
    private static func determineAccessModifier(from declaration: some DeclGroupSyntax) -> String {
        let isPublic = declaration.modifiers.contains { modifier in
            modifier.name.text == "public"
        }
        return isPublic ? "public " : ""
    }

    /// Generates the required declarations for the HTTP request
    private static func generateDeclarations(
        path: String,
        accessModifier: String,
        method: String
    ) -> [DeclSyntax] {
        let pathDecl = DeclSyntax(stringLiteral: "\(accessModifier)let path: String = \"\(path)\"")
        let methodDecl = DeclSyntax(
            stringLiteral: "\(accessModifier)let method: HttpMethod = .\(method)")

        return [pathDecl, methodDecl]
    }
}
