//
//  GetMacro.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

public struct GetMacro: MemberMacro, ExtensionMacro {

    // MARK: - MemberMacro Implementation

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        // Extract the path argument from the @Get macro
        guard let path = extractPathArgument(from: node, context: context, declaration: declaration)
        else {
            return []
        }

        // Determine access modifier based on the declaration
        let accessModifier = determineAccessModifier(from: declaration)

        // Find all @Query-annotated properties
        let queryIdentifiers = findQueryProperties(in: declaration)

        // Generate the required declarations
        return generateDeclarations(
            path: path,
            accessModifier: accessModifier,
            queryIdentifiers: queryIdentifiers
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

    /// Extracts the path argument from the @Get macro attribute
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
                        "@Get requires a string literal path argument")
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

    /// Finds all properties annotated with @Query in the declaration
    private static func findQueryProperties(in declaration: some DeclGroupSyntax) -> [String] {
        var queryIdentifiers: [String] = []

        for member in declaration.memberBlock.members {
            guard let varDecl = member.decl.as(VariableDeclSyntax.self),
                let binding = varDecl.bindings.first,
                let pattern = binding.pattern.as(IdentifierPatternSyntax.self)
            else { continue }

            // Check if this property has a @Query attribute
            if hasQueryAttribute(varDecl) {
                queryIdentifiers.append(pattern.identifier.text)
            }
        }

        return queryIdentifiers
    }

    /// Checks if a variable declaration has a @Query attribute
    private static func hasQueryAttribute(_ varDecl: VariableDeclSyntax) -> Bool {
        for attr in varDecl.attributes {
            guard let attribute = attr.as(AttributeSyntax.self) else { continue }

            let attributeName = attribute.attributeName.description.trimmingCharacters(
                in: .whitespacesAndNewlines)
            if attributeName == "Query" {
                return true
            }
        }
        return false
    }

    /// Generates the required declarations for the HTTP request
    private static func generateDeclarations(
        path: String,
        accessModifier: String,
        queryIdentifiers: [String]
    ) -> [DeclSyntax] {
        let pathDecl = DeclSyntax(stringLiteral: "\(accessModifier)let path: String = \"\(path)\"")
        let methodDecl = DeclSyntax(stringLiteral: "\(accessModifier)let method: HttpMethod = .get")
        let queryParametersDecl = generateQueryParametersDeclaration(
            accessModifier: accessModifier,
            queryIdentifiers: queryIdentifiers
        )

        return [pathDecl, methodDecl, queryParametersDecl]
    }

    /// Generates the queryParameters computed property declaration
    private static func generateQueryParametersDeclaration(
        accessModifier: String,
        queryIdentifiers: [String]
    ) -> DeclSyntax {
        let queryParamLines: [String] = queryIdentifiers.map { identifier in
            "_query\(identifier.prefix(1).uppercased() + identifier.dropFirst())"
        }

        return """
            \(raw: accessModifier)var queryParameters: [QueryParameter] {
                [
                    \(raw: queryParamLines.joined(separator: ",\n                "))
                ]
            }
            """
    }
}
