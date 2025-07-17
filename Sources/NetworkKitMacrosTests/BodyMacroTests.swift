//
//  BodyMacroTests.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 16/07/2025.
//

import NetworkKitMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class BodyMacroTests: XCTestCase {
    func testBodyMacroExpansion() {
        assertMacroExpansion(
            """
            @Body
            struct User {
                let name: String
                let email: String
            }
            """,
            expandedSource: """
                struct User {
                    let name: String
                    let email: String
                }

                extension User: HttpBody {
                }
                """,
            macros: ["Body": BodyMacro.self]
        )
    }

    func testBodyMacroExpansionWithPublicStruct() {
        assertMacroExpansion(
            """
            @Body
            public struct User {
                let name: String
                let email: String
            }
            """,
            expandedSource: """
                public struct User {
                    let name: String
                    let email: String
                }

                extension User: HttpBody {
                }
                """,
            macros: ["Body": BodyMacro.self]
        )
    }

    func testBodyMacroExpansionWithClass() {
        assertMacroExpansion(
            """
            @Body
            class UserProfile {
                let userId: Int
                let name: String
            
                init(userId: Int, name: String) {
                    self.userId = userId
                    self.name = name
                }
            }
            """,
            expandedSource: """
                class UserProfile {
                    let userId: Int
                    let name: String
                
                    init(userId: Int, name: String) {
                        self.userId = userId
                        self.name = name
                    }
                }

                extension UserProfile: HttpBody {
                }
                """,
            macros: ["Body": BodyMacro.self]
        )
    }

    func testBodyMacroExpansionWithEnum() {
        assertMacroExpansion(
            """
            @Body
            enum UserRole {
                case admin
                case user
                case guest
            }
            """,
            expandedSource: """
                enum UserRole {
                    case admin
                    case user
                    case guest
                }
                
                extension UserRole: HttpBody {
                }
                """,
            macros: ["Body": BodyMacro.self]
        )
    }

    func testBodyMacroExpansionWithGenericStruct() {
        assertMacroExpansion(
            """
            @Body
            struct ApiResponse<T> {
                let data: T
                let status: String
            }
            """,
            expandedSource: """
                struct ApiResponse<T> {
                    let data: T
                    let status: String
                }

                extension ApiResponse: HttpBody {
                }
                """,
            macros: ["Body": BodyMacro.self]
        )
    }

    func testBodyMacroExpansionWithConstrainedGeneric() {
        assertMacroExpansion(
            """
            @Body
            struct Repository<T: Codable> {
                let items: [T]
                let count: Int
            }
            """,
            expandedSource: """
                struct Repository<T: Codable> {
                    let items: [T]
                    let count: Int
                }

                extension Repository: HttpBody {
                }
                """,
            macros: ["Body": BodyMacro.self]
        )
    }

    func testBodyMacroExpansionWithExistingProtocolConformance() {
        assertMacroExpansion(
            """
            @Body
            struct User: Codable {
                let name: String
                let email: String
            }
            """,
            expandedSource: """
                struct User: Codable {
                    let name: String
                    let email: String
                }

                extension User: HttpBody {
                }
                """,
            macros: ["Body": BodyMacro.self]
        )
    }

    func testBodyMacroExpansionWithComplexStruct() {
        assertMacroExpansion(
            """
            @Body
            struct CreateUserRequest {
                let name: String
                let email: String
                let age: Int?
                let preferences: [String: Any]
            
                init(name: String, email: String, age: Int? = nil, preferences: [String: Any] = [:]) {
                    self.name = name
                    self.email = email
                    self.age = age
                    self.preferences = preferences
                }
            }
            """,
            expandedSource: """
                struct CreateUserRequest {
                    let name: String
                    let email: String
                    let age: Int?
                    let preferences: [String: Any]
                
                    init(name: String, email: String, age: Int? = nil, preferences: [String: Any] = [:]) {
                        self.name = name
                        self.email = email
                        self.age = age
                        self.preferences = preferences
                    }
                }

                extension CreateUserRequest: HttpBody {
                }
                """,
            macros: ["Body": BodyMacro.self]
        )
    }

    func testBodyMacroExpansionWithNestedTypes() {
        assertMacroExpansion(
            """
            @Body
            struct UserRegistration {
                let user: UserInfo
                let credentials: LoginCredentials
            
                struct UserInfo {
                    let name: String
                    let email: String
                }
            
                struct LoginCredentials {
                    let username: String
                    let password: String
                }
            }
            """,
            expandedSource: """
                struct UserRegistration {
                    let user: UserInfo
                    let credentials: LoginCredentials
                
                    struct UserInfo {
                        let name: String
                        let email: String
                    }
                
                    struct LoginCredentials {
                        let username: String
                        let password: String
                    }
                }

                extension UserRegistration: HttpBody {
                }
                """,
            macros: ["Body": BodyMacro.self]
        )
    }

    func testBodyMacroExpansionWithAccessModifiers() {
        assertMacroExpansion(
            """
            @Body
            internal struct InternalUser {
                private let id: UUID
                public let name: String
                internal let email: String
            }
            """,
            expandedSource: """
                internal struct InternalUser {
                    private let id: UUID
                    public let name: String
                    internal let email: String
                }

                extension InternalUser: HttpBody {
                }
                """,
            macros: ["Body": BodyMacro.self]
        )
    }

    func testBodyMacroExpansionWithComputedProperties() {
        assertMacroExpansion(
            """
            @Body
            struct User {
                let firstName: String
                let lastName: String
            
                var fullName: String {
                    return "\\(firstName) \\(lastName)"
                }
            }
            """,
            expandedSource: """
                struct User {
                    let firstName: String
                    let lastName: String
                
                    var fullName: String {
                        return "\\(firstName) \\(lastName)"
                    }
                }

                extension User: HttpBody {
                }
                """,
            macros: ["Body": BodyMacro.self]
        )
    }
}
