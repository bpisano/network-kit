//
//  HeadMacroTests.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 17/07/2025.
//

import NetworkKitMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class HeadMacroTests: XCTestCase {
    func testHeadMacroExpansion() {
        assertMacroExpansion(
            """
            @Head("/books")
            struct HeadBook {
            }
            """,
            expandedSource: """
                struct HeadBook {

                    let path: String = "/books"

                    let method: HttpMethod = .head

                    var queryParameters: [QueryParameter] {
                        [

                        ]
                    }

                    let body = EmptyBody()
                }

                extension HeadBook: HttpRequest {
                }
                """,
            macros: ["Head": HeadMacro.self]
        )
    }

    func testHeadMacroExpansionWithPublicStruct() {
        assertMacroExpansion(
            """
            @Head("/books")
            public struct HeadBook {
            }
            """,
            expandedSource: """
                public struct HeadBook {

                    public let path: String = "/books"

                    public let method: HttpMethod = .head

                    public var queryParameters: [QueryParameter] {
                        [

                        ]
                    }

                    public let body = EmptyBody()
                }

                extension HeadBook: HttpRequest {
                }
                """,
            macros: ["Head": HeadMacro.self]
        )
    }

    func testHeadMacroWithQueryProperties() {
        assertMacroExpansion(
            """
            @Head("/books")
            struct HeadBook {
                @Query
                var includeMetadata: Bool
            }
            """,
            expandedSource: """
                struct HeadBook {
                    var includeMetadata: Bool

                    var _queryIncludeMetadata: QueryParameter {
                        QueryParameter(key: "includeMetadata", value: includeMetadata)
                    }

                    let path: String = "/books"

                    let method: HttpMethod = .head

                    var queryParameters: [QueryParameter] {
                        [
                            _queryIncludeMetadata
                        ]
                    }

                    let body = EmptyBody()
                }

                extension HeadBook: HttpRequest {
                }
                """,
            macros: ["Head": HeadMacro.self, "Query": QueryMacro.self]
        )
    }

    func testHeadMacroWithPublicQueryProperties() {
        assertMacroExpansion(
            """
            @Head("/books")
            public struct HeadBook {
                @Query
                var includeMetadata: Bool
            }
            """,
            expandedSource: """
                public struct HeadBook {
                    var includeMetadata: Bool

                    var _queryIncludeMetadata: QueryParameter {
                        QueryParameter(key: "includeMetadata", value: includeMetadata)
                    }

                    public let path: String = "/books"

                    public let method: HttpMethod = .head

                    public var queryParameters: [QueryParameter] {
                        [
                            _queryIncludeMetadata
                        ]
                    }

                    public let body = EmptyBody()
                }

                extension HeadBook: HttpRequest {
                }
                """,
            macros: ["Head": HeadMacro.self, "Query": QueryMacro.self]
        )
    }

    func testHeadMacroWithBodyExpansion() {
        assertMacroExpansion(
            """
            @Head("/books")
            struct HeadBook {
                @Body
                struct HeadOptions {
                    let includeDeleted: Bool
                }
            }
            """,
            expandedSource: """
                struct HeadBook {
                    @Body
                    struct HeadOptions {
                        let includeDeleted: Bool
                    }

                    let path: String = "/books"

                    let method: HttpMethod = .head

                    var queryParameters: [QueryParameter] {
                        [

                        ]
                    }

                    let body: HeadOptions
                }

                extension HeadBook: HttpRequest {
                }
                """,
            macros: ["Head": HeadMacro.self]
        )
    }

    func testHeadMacroWithExistingBodyProperty() {
        assertMacroExpansion(
            """
            @Head("/books")
            struct HeadBook {
                let body: String = "existing body"
            }
            """,
            expandedSource: """
                struct HeadBook {
                    let body: String = "existing body"

                    let path: String = "/books"

                    let method: HttpMethod = .head

                    var queryParameters: [QueryParameter] {
                        [

                        ]
                    }
                }

                extension HeadBook: HttpRequest {
                }
                """,
            macros: ["Head": HeadMacro.self]
        )
    }
}
