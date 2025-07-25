//
//  OptionsMacroTests.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 17/07/2025.
//

import NetworkKitMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class OptionsMacroTests: XCTestCase {
    func testOptionsMacroExpansion() {
        assertMacroExpansion(
            """
            @Options("/books")
            struct OptionsBook {
            }
            """,
            expandedSource: """
                struct OptionsBook {

                    let path: String = "/books"

                    let method: HttpMethod = .options

                    var queryParameters: [QueryParameter] {
                        [

                        ]
                    }

                    let body = EmptyBody()
                }

                extension OptionsBook: HttpRequest {
                }
                """,
            macros: ["Options": OptionsMacro.self]
        )
    }

    func testOptionsMacroExpansionWithPublicStruct() {
        assertMacroExpansion(
            """
            @Options("/books")
            public struct OptionsBook {
            }
            """,
            expandedSource: """
                public struct OptionsBook {

                    public let path: String = "/books"

                    public let method: HttpMethod = .options

                    public var queryParameters: [QueryParameter] {
                        [

                        ]
                    }

                    public let body = EmptyBody()
                }

                extension OptionsBook: HttpRequest {
                }
                """,
            macros: ["Options": OptionsMacro.self]
        )
    }

    func testOptionsMacroWithQueryProperties() {
        assertMacroExpansion(
            """
            @Options("/books")
            struct OptionsBook {
                @Query
                var includeHidden: Bool
            }
            """,
            expandedSource: """
                struct OptionsBook {
                    var includeHidden: Bool

                    var _queryIncludeHidden: QueryParameter {
                        QueryParameter(key: "includeHidden", value: includeHidden)
                    }

                    let path: String = "/books"

                    let method: HttpMethod = .options

                    var queryParameters: [QueryParameter] {
                        [
                            _queryIncludeHidden
                        ]
                    }

                    let body = EmptyBody()
                }

                extension OptionsBook: HttpRequest {
                }
                """,
            macros: ["Options": OptionsMacro.self, "Query": QueryMacro.self]
        )
    }

    func testOptionsMacroWithPublicQueryProperties() {
        assertMacroExpansion(
            """
            @Options("/books")
            public struct OptionsBook {
                @Query
                var includeHidden: Bool
            }
            """,
            expandedSource: """
                public struct OptionsBook {
                    var includeHidden: Bool

                    var _queryIncludeHidden: QueryParameter {
                        QueryParameter(key: "includeHidden", value: includeHidden)
                    }

                    public let path: String = "/books"

                    public let method: HttpMethod = .options

                    public var queryParameters: [QueryParameter] {
                        [
                            _queryIncludeHidden
                        ]
                    }

                    public let body = EmptyBody()
                }

                extension OptionsBook: HttpRequest {
                }
                """,
            macros: ["Options": OptionsMacro.self, "Query": QueryMacro.self]
        )
    }

    func testOptionsMacroWithBodyExpansion() {
        assertMacroExpansion(
            """
            @Options("/books")
            struct OptionsBook {
                @Body
                struct OptionsFilter {
                    let scope: String
                }
            }
            """,
            expandedSource: """
                struct OptionsBook {
                    @Body
                    struct OptionsFilter {
                        let scope: String
                    }

                    let path: String = "/books"

                    let method: HttpMethod = .options

                    var queryParameters: [QueryParameter] {
                        [

                        ]
                    }

                    let body: OptionsFilter
                }

                extension OptionsBook: HttpRequest {
                }
                """,
            macros: ["Options": OptionsMacro.self]
        )
    }

    func testOptionsMacroWithExistingBodyProperty() {
        assertMacroExpansion(
            """
            @Options("/books")
            struct OptionsBook {
                let body: String = "existing body"
            }
            """,
            expandedSource: """
                struct OptionsBook {
                    let body: String = "existing body"

                    let path: String = "/books"

                    let method: HttpMethod = .options

                    var queryParameters: [QueryParameter] {
                        [

                        ]
                    }
                }

                extension OptionsBook: HttpRequest {
                }
                """,
            macros: ["Options": OptionsMacro.self]
        )
    }
}
