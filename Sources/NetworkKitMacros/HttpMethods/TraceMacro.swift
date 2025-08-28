//
//  TraceMacro.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

public struct TraceMacro: MemberMacro, ExtensionMacro {

    // MARK: - MemberMacro Implementation

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        // Extract the path and response type arguments from the @Trace macro
        guard
            let (path, responseType) = extractArguments(
                from: node, context: context, declaration: declaration)
        else {
            return []
        }

        // Determine access modifier based on the declaration
        let accessModifier = determineAccessModifier(from: declaration)

        // Find all @Query-annotated properties
        let queryIdentifiers = findQueryProperties(in: declaration)

        // Find the @Body struct
        let bodyType = findBodyType(in: declaration)

        // Check if there's already a body property defined
        let hasExistingBody = hasExistingBodyProperty(in: declaration)

        // Generate the required declarations
        return generateDeclarations(
            path: path,
            responseType: responseType,
            accessModifier: accessModifier,
            method: "trace",
            queryIdentifiers: queryIdentifiers,
            bodyType: bodyType,
            hasExistingBody: hasExistingBody
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

    /// Extracts the path and response type arguments from the @Trace macro attribute
    private static func extractArguments(
        from node: AttributeSyntax,
        context: some MacroExpansionContext,
        declaration: some DeclGroupSyntax
    ) -> (path: String, responseType: String?)? {
        guard let arguments = node.arguments?.as(LabeledExprListSyntax.self) else {
            context.diagnose(
                .init(
                    node: declaration,
                    message: MacroExpansionErrorMessage(
                        "@Trace requires a string literal path argument")
                )
            )
            return nil
        }

        // Extract path (first argument)
        guard let firstArg = arguments.first,
            let pathExpr = firstArg.expression.as(StringLiteralExprSyntax.self),
            let path = pathExpr.segments.first?.description.trimmingCharacters(
                in: .init(charactersIn: "\""))
        else {
            context.diagnose(
                .init(
                    node: declaration,
                    message: MacroExpansionErrorMessage(
                        "@Trace requires a string literal path argument")
                )
            )
            return nil
        }

        // Extract response type (second argument, labeled with "of:")
        var responseType: String? = nil
        if arguments.count > 1 {
            for argument in arguments.dropFirst() {
                if let label = argument.label, label.text == "of" {
                    // Handle member access expressions like [User].self
                    if let memberAccess = argument.expression.as(MemberAccessExprSyntax.self),
                        let base = memberAccess.base
                    {
                        responseType = base.description.trimmingCharacters(
                            in: .whitespacesAndNewlines)
                    }
                    break
                }
            }
        }

        return (path: path, responseType: responseType)
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

    /// Finds the name of the nested type annotated with @Body
    private static func findBodyType(in declaration: some DeclGroupSyntax) -> String? {
        for member in declaration.memberBlock.members {
            guard let structDecl = member.decl.as(StructDeclSyntax.self) else { continue }

            for attr in structDecl.attributes {
                guard let attribute = attr.as(AttributeSyntax.self),
                    attribute.attributeName.trimmed.description == "Body"
                else { continue }

                return structDecl.name.text
            }
        }

        return nil
    }

    /// Checks if the struct already has a body property defined
    private static func hasExistingBodyProperty(in declaration: some DeclGroupSyntax) -> Bool {
        for member in declaration.memberBlock.members {
            guard let varDecl = member.decl.as(VariableDeclSyntax.self),
                let binding = varDecl.bindings.first,
                let pattern = binding.pattern.as(IdentifierPatternSyntax.self)
            else { continue }

            if pattern.identifier.text == "body" {
                return true
            }
        }
        return false
    }

    /// Generates the required declarations for the HTTP request
    private static func generateDeclarations(
        path: String,
        responseType: String?,
        accessModifier: String,
        method: String,
        queryIdentifiers: [String],
        bodyType: String?,
        hasExistingBody: Bool
    ) -> [DeclSyntax] {
        var declarations: [DeclSyntax] = []

        // Add response type alias if provided
        if let responseType = responseType {
            let typealiasDecl = DeclSyntax(stringLiteral: "\(accessModifier)typealias Response = \(responseType)")
            declarations.append(typealiasDecl)
        } else {
            // Default to EmptyResponse if no response type is specified
            let typealiasDecl = DeclSyntax(stringLiteral: "\(accessModifier)typealias Response = Empty")
            declarations.append(typealiasDecl)
        }

        let pathDecl = DeclSyntax(stringLiteral: "\(accessModifier)let path: String = \"\(path)\"")
        let methodDecl = DeclSyntax(
            stringLiteral: "\(accessModifier)let method: HttpMethod = .\(method)")
        let queryParametersDecl = generateQueryParametersDeclaration(
            accessModifier: accessModifier,
            queryIdentifiers: queryIdentifiers
        )

        declarations.append(contentsOf: [pathDecl, methodDecl, queryParametersDecl])

        // Add body property if there's a body type
        if let bodyType = bodyType {
            let bodyDecl = DeclSyntax(stringLiteral: "\(accessModifier)let body: \(bodyType)")
            declarations.append(bodyDecl)
        } else if !hasExistingBody {
            // Add default empty body if no body type is specified and no existing body property
            let emptyBodyDecl = DeclSyntax(stringLiteral: "\(accessModifier)let body = EmptyBody()")
            declarations.append(emptyBodyDecl)
        }

        return declarations
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
                    \(raw: queryParamLines.joined(separator: ",\n"))
                ]
            }
            """
    }
}
