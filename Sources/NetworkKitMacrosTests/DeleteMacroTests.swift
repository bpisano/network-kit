//
//  DeleteMacroTests.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 17/07/2025.
//

import NetworkKitMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class DeleteMacroTests: XCTestCase {
    func testDeleteMacroExpansion() {
        assertMacroExpansion(
            """
            @Delete("/books/1")
            struct DeleteBook {
            }
            """,
            expandedSource: """
                struct DeleteBook {

                    let path: String = "/books/1"

                    let method: HttpMethod = .delete

                    var queryParameters: [QueryParameter] {
                        [

                        ]
                    }

                    let body = EmptyBody()
                }

                extension DeleteBook: HttpRequest {
                }
                """,
            macros: ["Delete": DeleteMacro.self]
        )
    }

    func testDeleteMacroExpansionWithPublicStruct() {
        assertMacroExpansion(
            """
            @Delete("/books/1")
            public struct DeleteBook {
            }
            """,
            expandedSource: """
                public struct DeleteBook {

                    public let path: String = "/books/1"

                    public let method: HttpMethod = .delete

                    public var queryParameters: [QueryParameter] {
                        [

                        ]
                    }

                    public let body = EmptyBody()
                }

                extension DeleteBook: HttpRequest {
                }
                """,
            macros: ["Delete": DeleteMacro.self]
        )
    }

    func testDeleteMacroWithQueryProperties() {
        assertMacroExpansion(
            """
            @Delete("/books/1")
            struct DeleteBook {
                @Query
                var force: Bool
            }
            """,
            expandedSource: """
                struct DeleteBook {
                    var force: Bool

                    var _queryForce: QueryParameter {
                        QueryParameter(key: "force", value: force)
                    }

                    let path: String = "/books/1"

                    let method: HttpMethod = .delete

                    var queryParameters: [QueryParameter] {
                        [
                            _queryForce
                        ]
                    }

                    let body = EmptyBody()
                }

                extension DeleteBook: HttpRequest {
                }
                """,
            macros: ["Delete": DeleteMacro.self, "Query": QueryMacro.self]
        )
    }

    func testDeleteMacroWithPublicQueryProperties() {
        assertMacroExpansion(
            """
            @Delete("/books/1")
            public struct DeleteBook {
                @Query
                var force: Bool
            }
            """,
            expandedSource: """
                public struct DeleteBook {
                    var force: Bool

                    var _queryForce: QueryParameter {
                        QueryParameter(key: "force", value: force)
                    }

                    public let path: String = "/books/1"

                    public let method: HttpMethod = .delete

                    public var queryParameters: [QueryParameter] {
                        [
                            _queryForce
                        ]
                    }

                    public let body = EmptyBody()
                }

                extension DeleteBook: HttpRequest {
                }
                """,
            macros: ["Delete": DeleteMacro.self, "Query": QueryMacro.self]
        )
    }

    func testDeleteMacroWithBodyExpansion() {
        assertMacroExpansion(
            """
            @Delete("/books/1")
            struct DeleteBook {
                @Body
                struct DeleteOptions {
                    let force: Bool
                }
            }
            """,
            expandedSource: """
                struct DeleteBook {
                    @Body
                    struct DeleteOptions {
                        let force: Bool
                    }

                    let path: String = "/books/1"

                    let method: HttpMethod = .delete

                    var queryParameters: [QueryParameter] {
                        [

                        ]
                    }

                    let body: DeleteOptions
                }

                extension DeleteBook: HttpRequest {
                }
                """,
            macros: ["Delete": DeleteMacro.self]
        )
    }

    func testDeleteMacroWithExistingBodyProperty() {
        assertMacroExpansion(
            """
            @Delete("/books/1")
            struct DeleteBook {
                let body: String = "existing body"
            }
            """,
            expandedSource: """
                struct DeleteBook {
                    let body: String = "existing body"

                    let path: String = "/books/1"

                    let method: HttpMethod = .delete

                    var queryParameters: [QueryParameter] {
                        [

                        ]
                    }
                }

                extension DeleteBook: HttpRequest {
                }
                """,
            macros: ["Delete": DeleteMacro.self]
        )
    }
}
