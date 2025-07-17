//
//  PutMacroTests.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 17/07/2025.
//

import NetworkKitMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class PutMacroTests: XCTestCase {
    func testPutMacroExpansion() {
        assertMacroExpansion(
            """
            @Put("/books/1")
            struct UpdateBook {
            }
            """,
            expandedSource: """
                struct UpdateBook {

                    let path: String = "/books/1"

                    let method: HttpMethod = .put

                    var queryParameters: [QueryParameter] {
                        [

                        ]
                    }

                    let body = EmptyBody()
                }

                extension UpdateBook: HttpRequest {
                }
                """,
            macros: ["Put": PutMacro.self]
        )
    }

    func testPutMacroExpansionWithPublicStruct() {
        assertMacroExpansion(
            """
            @Put("/books/1")
            public struct UpdateBook {
            }
            """,
            expandedSource: """
                public struct UpdateBook {

                    public let path: String = "/books/1"

                    public let method: HttpMethod = .put

                    public var queryParameters: [QueryParameter] {
                        [

                        ]
                    }

                    public let body = EmptyBody()
                }

                extension UpdateBook: HttpRequest {
                }
                """,
            macros: ["Put": PutMacro.self]
        )
    }

    func testPutMacroWithQueryProperties() {
        assertMacroExpansion(
            """
            @Put("/books/1")
            struct UpdateBook {
                @Query
                var force: Bool
            }
            """,
            expandedSource: """
                struct UpdateBook {
                    var force: Bool

                    var _queryForce: QueryParameter {
                        QueryParameter(key: "force", value: force)
                    }

                    let path: String = "/books/1"

                    let method: HttpMethod = .put

                    var queryParameters: [QueryParameter] {
                        [
                            _queryForce
                        ]
                    }

                    let body = EmptyBody()
                }

                extension UpdateBook: HttpRequest {
                }
                """,
            macros: ["Put": PutMacro.self, "Query": QueryMacro.self]
        )
    }

    func testPutMacroWithPublicQueryProperties() {
        assertMacroExpansion(
            """
            @Put("/books/1")
            public struct UpdateBook {
                @Query
                var force: Bool
            }
            """,
            expandedSource: """
                public struct UpdateBook {
                    var force: Bool

                    var _queryForce: QueryParameter {
                        QueryParameter(key: "force", value: force)
                    }

                    public let path: String = "/books/1"

                    public let method: HttpMethod = .put

                    public var queryParameters: [QueryParameter] {
                        [
                            _queryForce
                        ]
                    }

                    public let body = EmptyBody()
                }

                extension UpdateBook: HttpRequest {
                }
                """,
            macros: ["Put": PutMacro.self, "Query": QueryMacro.self]
        )
    }

    func testPutMacroWithBodyExpansion() {
        assertMacroExpansion(
            """
            @Put("/books/1")
            struct UpdateBook {
                @Body
                struct BookUpdate {
                    let name: String
                }
            }
            """,
            expandedSource: """
                struct UpdateBook {
                    @Body
                    struct BookUpdate {
                        let name: String
                    }

                    let path: String = "/books/1"

                    let method: HttpMethod = .put

                    var queryParameters: [QueryParameter] {
                        [

                        ]
                    }

                    let body: BookUpdate
                }

                extension UpdateBook: HttpRequest {
                }
                """,
            macros: ["Put": PutMacro.self]
        )
    }

    func testPutMacroWithExistingBodyProperty() {
        assertMacroExpansion(
            """
            @Put("/books/1")
            struct UpdateBook {
                let body: String = "existing body"
            }
            """,
            expandedSource: """
                struct UpdateBook {
                    let body: String = "existing body"

                    let path: String = "/books/1"

                    let method: HttpMethod = .put

                    var queryParameters: [QueryParameter] {
                        [

                        ]
                    }
                }

                extension UpdateBook: HttpRequest {
                }
                """,
            macros: ["Put": PutMacro.self]
        )
    }
}
