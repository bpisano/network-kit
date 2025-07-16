//
//  HttpMethodMacrosTests.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import NetworkKitMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

@Suite("Http Method Macros")
struct MacroTests {
    @Test
    func testGetMacroExpansion() {
        assertMacroExpansion(
            """
            @Get("/books")
            struct GetBook {
            }
            """,
            expandedSource: """
                struct GetBook: HttpRequest {
                    let path: String = "/books"
                    let method: HttpMethod = .get
                    var queryParameters: [QueryParameter] {
                        [
                            
                        ]
                    }
                }
                """,
            macros: ["Get": GetMacro.self]
        )
    }

    @Test
    func testGetMacroExpansionWithPublicStruct() {
        assertMacroExpansion(
            """
            @Get("/books")
            public struct GetBook {
            }
            """,
            expandedSource: """
                public struct GetBook: HttpRequest {
                    public let path: String = "/books"
                    public let method: HttpMethod = .get
                    public var queryParameters: [QueryParameter] {
                        [
                            
                        ]
                    }
                }
                """,
            macros: ["Get": GetMacro.self]
        )
    }

    @Test
    func testGetMacroWithQueryProperties() {
        assertMacroExpansion(
            """
            @Get("/books")
            struct GetBook {
                @Query
                var search: String
                
                @Query("page_size")
                var pageSize: String
            }
            """,
            expandedSource: """
                struct GetBook: HttpRequest {
                    let path: String = "/books"
                    let method: HttpMethod = .get
                    var queryParameters: [QueryParameter] {
                        [
                            _querySearch,
                            _queryPageSize
                        ]
                    }
                    var search: String

                    var _querySearch: QueryParameter {
                        QueryParameter(key: "search", value: search)
                    }
                    
                    var pageSize: String

                    var _queryPageSize: QueryParameter {
                        QueryParameter(key: "page_size", value: pageSize)
                    }
                }
                """,
            macros: ["Get": GetMacro.self, "Query": QueryMacro.self]
        )
    }

    @Test
    func testGetMacroWithPublicQueryProperties() {
        assertMacroExpansion(
            """
            @Get("/books")
            public struct GetBook {
                @Query
                var search: String
            }
            """,
            expandedSource: """
                public struct GetBook: HttpRequest {
                    public let path: String = "/books"
                    public let method: HttpMethod = .get
                    public var queryParameters: [QueryParameter] {
                        [
                            _querySearch
                        ]
                    }
                    var search: String

                    var _querySearch: QueryParameter {
                        QueryParameter(key: "search", value: search)
                    }
                }
                """,
            macros: ["Get": GetMacro.self, "Query": QueryMacro.self]
        )
    }

    @Test
    func testPostMacroExpansion() {
        assertMacroExpansion(
            """
            @Post("/books")
            struct CreateBook {
            }
            """,
            expandedSource: """
                struct CreateBook: HttpRequest {
                    let path: String = "/books"
                    let method: HttpMethod = .post
                }
                """,
            macros: ["Post": PostMacro.self]
        )
    }

    @Test
    func testPostMacroExpansionWithPublicStruct() {
        assertMacroExpansion(
            """
            @Post("/books")
            public struct CreateBook {
            }
            """,
            expandedSource: """
                public struct CreateBook: HttpRequest {
                    public let path: String = "/books"
                    public let method: HttpMethod = .post
                }
                """,
            macros: ["Post": PostMacro.self]
        )
    }

    @Test
    func testPutMacroExpansion() {
        assertMacroExpansion(
            """
            @Put("/books/1")
            struct UpdateBook {
            }
            """,
            expandedSource: """
                struct UpdateBook: HttpRequest {
                    let path: String = "/books/1"
                    let method: HttpMethod = .put
                }
                """,
            macros: ["Put": PutMacro.self]
        )
    }

    @Test
    func testPutMacroExpansionWithPublicStruct() {
        assertMacroExpansion(
            """
            @Put("/books/1")
            public struct UpdateBook {
            }
            """,
            expandedSource: """
                public struct UpdateBook: HttpRequest {
                    public let path: String = "/books/1"
                    public let method: HttpMethod = .put
                }
                """,
            macros: ["Put": PutMacro.self]
        )
    }

    @Test
    func testPatchMacroExpansion() {
        assertMacroExpansion(
            """
            @Patch("/books/1")
            struct PartialUpdateBook {
            }
            """,
            expandedSource: """
                struct PartialUpdateBook: HttpRequest {
                    let path: String = "/books/1"
                    let method: HttpMethod = .patch
                }
                """,
            macros: ["Patch": PatchMacro.self]
        )
    }

    @Test
    func testPatchMacroExpansionWithPublicStruct() {
        assertMacroExpansion(
            """
            @Patch("/books/1")
            public struct PartialUpdateBook {
            }
            """,
            expandedSource: """
                public struct PartialUpdateBook: HttpRequest {
                    public let path: String = "/books/1"
                    public let method: HttpMethod = .patch
                }
                """,
            macros: ["Patch": PatchMacro.self]
        )
    }

    @Test
    func testDeleteMacroExpansion() {
        assertMacroExpansion(
            """
            @Delete("/books/1")
            struct DeleteBook {
            }
            """,
            expandedSource: """
                struct DeleteBook: HttpRequest {
                    let path: String = "/books/1"
                    let method: HttpMethod = .delete
                }
                """,
            macros: ["Delete": DeleteMacro.self]
        )
    }

    @Test
    func testDeleteMacroExpansionWithPublicStruct() {
        assertMacroExpansion(
            """
            @Delete("/books/1")
            public struct DeleteBook {
            }
            """,
            expandedSource: """
                public struct DeleteBook: HttpRequest {
                    public let path: String = "/books/1"
                    public let method: HttpMethod = .delete
                }
                """,
            macros: ["Delete": DeleteMacro.self]
        )
    }

    @Test
    func testOptionsMacroExpansion() {
        assertMacroExpansion(
            """
            @Options("/books")
            struct OptionsBook {
            }
            """,
            expandedSource: """
                struct OptionsBook: HttpRequest {
                    let path: String = "/books"
                    let method: HttpMethod = .options
                }
                """,
            macros: ["Options": OptionsMacro.self]
        )
    }

    @Test
    func testOptionsMacroExpansionWithPublicStruct() {
        assertMacroExpansion(
            """
            @Options("/books")
            public struct OptionsBook {
            }
            """,
            expandedSource: """
                public struct OptionsBook: HttpRequest {
                    public let path: String = "/books"
                    public let method: HttpMethod = .options
                }
                """,
            macros: ["Options": OptionsMacro.self]
        )
    }

    @Test
    func testHeadMacroExpansion() {
        assertMacroExpansion(
            """
            @Head("/books")
            struct HeadBook {
            }
            """,
            expandedSource: """
                struct HeadBook: HttpRequest {
                    let path: String = "/books"
                    let method: HttpMethod = .head
                }
                """,
            macros: ["Head": HeadMacro.self]
        )
    }

    @Test
    func testHeadMacroExpansionWithPublicStruct() {
        assertMacroExpansion(
            """
            @Head("/books")
            public struct HeadBook {
            }
            """,
            expandedSource: """
                public struct HeadBook: HttpRequest {
                    public let path: String = "/books"
                    public let method: HttpMethod = .head
                }
                """,
            macros: ["Head": HeadMacro.self]
        )
    }

    @Test
    func testTraceMacroExpansion() {
        assertMacroExpansion(
            """
            @Trace("/books")
            struct TraceBook {
            }
            """,
            expandedSource: """
                struct TraceBook: HttpRequest {
                    let path: String = "/books"
                    let method: HttpMethod = .trace
                }
                """,
            macros: ["Trace": TraceMacro.self]
        )
    }

    @Test
    func testTraceMacroExpansionWithPublicStruct() {
        assertMacroExpansion(
            """
            @Trace("/books")
            public struct TraceBook {
            }
            """,
            expandedSource: """
                public struct TraceBook: HttpRequest {
                    public let path: String = "/books"
                    public let method: HttpMethod = .trace
                }
                """,
            macros: ["Trace": TraceMacro.self]
        )
    }

    @Test
    func testConnectMacroExpansion() {
        assertMacroExpansion(
            """
            @Connect("/books")
            struct ConnectBook {
            }
            """,
            expandedSource: """
                struct ConnectBook: HttpRequest {
                    let path: String = "/books"
                    let method: HttpMethod = .connect
                }
                """,
            macros: ["Connect": ConnectMacro.self]
        )
    }

    @Test
    func testConnectMacroExpansionWithPublicStruct() {
        assertMacroExpansion(
            """
            @Connect("/books")
            public struct ConnectBook {
            }
            """,
            expandedSource: """
                public struct ConnectBook: HttpRequest {
                    public let path: String = "/books"
                    public let method: HttpMethod = .connect
                }
                """,
            macros: ["Connect": ConnectMacro.self]
        )
    }
}
