//
//  QueryMacroTests.swift
//  NetworkKit
//
//  Created by GitHub Copilot on 16/07/2025.
//

import NetworkKitMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

@Suite("Query Macro")
struct QueryMacroTests {
    @Test
    func testQueryMacroBasicExpansion() {
        assertMacroExpansion(
            """
            struct TestRequest {
                @Query
                var search: String
            }
            """,
            expandedSource: """
                struct TestRequest {
                    var search: String

                    var _querySearch: QueryParameter {
                        QueryParameter(key: "search", value: search)
                    }
                }
                """,
            macros: ["Query": QueryMacro.self]
        )
    }

    @Test
    func testQueryMacroWithCustomKey() {
        assertMacroExpansion(
            """
            struct TestRequest {
                @Query("q")
                var search: String
            }
            """,
            expandedSource: """
                struct TestRequest {
                    var search: String

                    var _querySearch: QueryParameter {
                        QueryParameter(key: "q", value: search)
                    }
                }
                """,
            macros: ["Query": QueryMacro.self]
        )
    }

    @Test
    func testQueryMacroWithExplicitStringType() {
        assertMacroExpansion(
            """
            struct TestRequest {
                @Query
                var category: String
            }
            """,
            expandedSource: """
                struct TestRequest {
                    var category: String

                    var _queryCategory: QueryParameter {
                        QueryParameter(key: "category", value: category)
                    }
                }
                """,
            macros: ["Query": QueryMacro.self]
        )
    }

    @Test
    func testQueryMacroWithMultipleProperties() {
        assertMacroExpansion(
            """
            struct TestRequest {
                @Query
                var search: String
                
                @Query("page_size")
                var pageSize: String
                
                @Query
                var filter: String
            }
            """,
            expandedSource: """
                struct TestRequest {
                    var search: String

                    var _querySearch: QueryParameter {
                        QueryParameter(key: "search", value: search)
                    }
                    
                    var pageSize: String

                    var _queryPageSize: QueryParameter {
                        QueryParameter(key: "page_size", value: pageSize)
                    }
                    
                    var filter: String

                    var _queryFilter: QueryParameter {
                        QueryParameter(key: "filter", value: filter)
                    }
                }
                """,
            macros: ["Query": QueryMacro.self]
        )
    }

    @Test
    func testQueryMacroWithSingleCharacterProperty() {
        assertMacroExpansion(
            """
            struct TestRequest {
                @Query
                var q: String
            }
            """,
            expandedSource: """
                struct TestRequest {
                    var q: String

                    var _queryQ: QueryParameter {
                        QueryParameter(key: "q", value: q)
                    }
                }
                """,
            macros: ["Query": QueryMacro.self]
        )
    }

    @Test
    func testQueryMacroWithCamelCaseProperty() {
        assertMacroExpansion(
            """
            struct TestRequest {
                @Query
                var userName: String
            }
            """,
            expandedSource: """
                struct TestRequest {
                    var userName: String

                    var _queryUserName: QueryParameter {
                        QueryParameter(key: "userName", value: userName)
                    }
                }
                """,
            macros: ["Query": QueryMacro.self]
        )
    }

    @Test
    func testQueryMacroWithSnakeCaseKey() {
        assertMacroExpansion(
            """
            struct TestRequest {
                @Query("user_name")
                var userName: String
            }
            """,
            expandedSource: """
                struct TestRequest {
                    var userName: String

                    var _queryUserName: QueryParameter {
                        QueryParameter(key: "user_name", value: userName)
                    }
                }
                """,
            macros: ["Query": QueryMacro.self]
        )
    }

    @Test
    func testQueryMacroWithEmptyStringKey() {
        assertMacroExpansion(
            """
            struct TestRequest {
                @Query("")
                var search: String
            }
            """,
            expandedSource: """
                struct TestRequest {
                    var search: String

                    var _querySearch: QueryParameter {
                        QueryParameter(key: "", value: search)
                    }
                }
                """,
            macros: ["Query": QueryMacro.self]
        )
    }

    @Test
    func testQueryMacroWithSpecialCharactersInKey() {
        assertMacroExpansion(
            """
            struct TestRequest {
                @Query("filter[name]")
                var filterName: String
            }
            """,
            expandedSource: """
                struct TestRequest {
                    var filterName: String

                    var _queryFilterName: QueryParameter {
                        QueryParameter(key: "filter[name]", value: filterName)
                    }
                }
                """,
            macros: ["Query": QueryMacro.self]
        )
    }

    @Test
    func testQueryMacroErrorOnNonVariableDeclaration() {
        assertMacroExpansion(
            """
            struct TestRequest {
                @Query
                func search() -> String { "" }
            }
            """,
            expandedSource: """
                struct TestRequest {
                    func search() -> String { "" }
                }
                """,
            diagnostics: [
                .init(
                    message: "@Query can only be applied to stored properties.",
                    line: 2,
                    column: 5
                )
            ],
            macros: ["Query": QueryMacro.self]
        )
    }

    @Test
    func testQueryMacroErrorOnNonStringType() {
        assertMacroExpansion(
            """
            struct TestRequest {
                @Query
                var count: Int
            }
            """,
            expandedSource: """
                struct TestRequest {
                    var count: Int

                    var _queryCount: QueryParameter {
                        QueryParameter(key: "count", value: count)
                    }
                }
                """,
            macros: ["Query": QueryMacro.self]
        )
    }

    @Test
    func testQueryMacroWithOptionalStringType() {
        assertMacroExpansion(
            """
            struct TestRequest {
                @Query
                var search: String?
            }
            """,
            expandedSource: """
                struct TestRequest {
                    var search: String?

                    var _querySearch: QueryParameter {
                        QueryParameter(key: "search", value: search)
                    }
                }
                """,
            macros: ["Query": QueryMacro.self]
        )
    }

    @Test
    func testQueryMacroWithInferredStringType() {
        assertMacroExpansion(
            """
            struct TestRequest {
                @Query
                var search = "default"
            }
            """,
            expandedSource: """
                struct TestRequest {
                    var search: String = "default"

                    var _querySearch: QueryParameter {
                        QueryParameter(key: "search", value: search)
                    }
                }
                """,
            macros: ["Query": QueryMacro.self]
        )
    }

    @Test
    func testQueryMacroWithPublicProperty() {
        assertMacroExpansion(
            """
            struct TestRequest {
                @Query
                public var search: String
            }
            """,
            expandedSource: """
                struct TestRequest {
                    public var search: String

                    var _querySearch: QueryParameter {
                        QueryParameter(key: "search", value: search)
                    }
                }
                """,
            macros: ["Query": QueryMacro.self]
        )
    }

    @Test
    func testQueryMacroWithPrivateProperty() {
        assertMacroExpansion(
            """
            struct TestRequest {
                @Query
                private var search: String
            }
            """,
            expandedSource: """
                struct TestRequest {
                    private var search: String

                    var _querySearch: QueryParameter {
                        QueryParameter(key: "search", value: search)
                    }
                }
                """,
            macros: ["Query": QueryMacro.self]
        )
    }
}
