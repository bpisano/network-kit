//
//  HttpMethodMacrosTests.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

#if canImport(NetworkKitMacros)
    import NetworkKitMacros
#endif

@Suite("Http Method Macros")
struct MacroTests {
    @Test
    func testGetMacroExpansion() {
        #if canImport(NetworkKitMacros)
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
                    }
                    """,
                macros: ["Get": GetMacro.self]
            )
        #endif
    }

    @Test
    func testGetMacroExpansionWithPublicStruct() {
        #if canImport(NetworkKitMacros)
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
                    }
                    """,
                macros: ["Get": GetMacro.self]
            )
        #endif
    }

    @Test
    func testPostMacroExpansion() {
        #if canImport(NetworkKitMacros)
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
        #endif
    }

    @Test
    func testPostMacroExpansionWithPublicStruct() {
        #if canImport(NetworkKitMacros)
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
        #endif
    }

    @Test
    func testPutMacroExpansion() {
        #if canImport(NetworkKitMacros)
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
        #endif
    }

    @Test
    func testPutMacroExpansionWithPublicStruct() {
        #if canImport(NetworkKitMacros)
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
        #endif
    }

    @Test
    func testPatchMacroExpansion() {
        #if canImport(NetworkKitMacros)
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
        #endif
    }

    @Test
    func testPatchMacroExpansionWithPublicStruct() {
        #if canImport(NetworkKitMacros)
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
        #endif
    }

    @Test
    func testDeleteMacroExpansion() {
        #if canImport(NetworkKitMacros)
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
        #endif
    }

    @Test
    func testDeleteMacroExpansionWithPublicStruct() {
        #if canImport(NetworkKitMacros)
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
        #endif
    }

    @Test
    func testOptionsMacroExpansion() {
        #if canImport(NetworkKitMacros)
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
        #endif
    }

    @Test
    func testOptionsMacroExpansionWithPublicStruct() {
        #if canImport(NetworkKitMacros)
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
        #endif
    }

    @Test
    func testHeadMacroExpansion() {
        #if canImport(NetworkKitMacros)
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
        #endif
    }

    @Test
    func testHeadMacroExpansionWithPublicStruct() {
        #if canImport(NetworkKitMacros)
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
        #endif
    }

    @Test
    func testTraceMacroExpansion() {
        #if canImport(NetworkKitMacros)
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
        #endif
    }

    @Test
    func testTraceMacroExpansionWithPublicStruct() {
        #if canImport(NetworkKitMacros)
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
        #endif
    }

    @Test
    func testConnectMacroExpansion() {
        #if canImport(NetworkKitMacros)
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
        #endif
    }

    @Test
    func testConnectMacroExpansionWithPublicStruct() {
        #if canImport(NetworkKitMacros)
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
        #endif
    }
}
