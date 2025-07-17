//
//  PatchMacroTests.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 17/07/2025.
//

import NetworkKitMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class PatchMacroTests: XCTestCase {
    func testPatchMacroExpansion() {
        assertMacroExpansion(
            """
            @Patch("/books/1")
            struct PartialUpdateBook {
            }
            """,
            expandedSource: """
                struct PartialUpdateBook {

                    let path: String = "/books/1"

                    let method: HttpMethod = .patch

                    var queryParameters: [QueryParameter] {
                        [

                        ]
                    }

                    let body = EmptyBody()
                }

                extension PartialUpdateBook: HttpRequest {
                }
                """,
            macros: ["Patch": PatchMacro.self]
        )
    }

    func testPatchMacroExpansionWithPublicStruct() {
        assertMacroExpansion(
            """
            @Patch("/books/1")
            public struct PartialUpdateBook {
            }
            """,
            expandedSource: """
                public struct PartialUpdateBook {

                    public let path: String = "/books/1"

                    public let method: HttpMethod = .patch

                    public var queryParameters: [QueryParameter] {
                        [

                        ]
                    }

                    public let body = EmptyBody()
                }

                extension PartialUpdateBook: HttpRequest {
                }
                """,
            macros: ["Patch": PatchMacro.self]
        )
    }

    func testPatchMacroWithQueryProperties() {
        assertMacroExpansion(
            """
            @Patch("/books/1")
            struct PartialUpdateBook {
                @Query
                var force: Bool
            }
            """,
            expandedSource: """
                struct PartialUpdateBook {
                    var force: Bool

                    var _queryForce: QueryParameter {
                        QueryParameter(key: "force", value: force)
                    }

                    let path: String = "/books/1"

                    let method: HttpMethod = .patch

                    var queryParameters: [QueryParameter] {
                        [
                            _queryForce
                        ]
                    }

                    let body = EmptyBody()
                }

                extension PartialUpdateBook: HttpRequest {
                }
                """,
            macros: ["Patch": PatchMacro.self, "Query": QueryMacro.self]
        )
    }

    func testPatchMacroWithPublicQueryProperties() {
        assertMacroExpansion(
            """
            @Patch("/books/1")
            public struct PartialUpdateBook {
                @Query
                var force: Bool
            }
            """,
            expandedSource: """
                public struct PartialUpdateBook {
                    var force: Bool

                    var _queryForce: QueryParameter {
                        QueryParameter(key: "force", value: force)
                    }

                    public let path: String = "/books/1"

                    public let method: HttpMethod = .patch

                    public var queryParameters: [QueryParameter] {
                        [
                            _queryForce
                        ]
                    }

                    public let body = EmptyBody()
                }

                extension PartialUpdateBook: HttpRequest {
                }
                """,
            macros: ["Patch": PatchMacro.self, "Query": QueryMacro.self]
        )
    }

    func testPatchMacroWithBodyExpansion() {
        assertMacroExpansion(
            """
            @Patch("/books/1")
            struct PartialUpdateBook {
                @Body
                struct BookPatch {
                    let name: String?
                }
            }
            """,
            expandedSource: """
                struct PartialUpdateBook {
                    @Body
                    struct BookPatch {
                        let name: String?
                    }

                    let path: String = "/books/1"

                    let method: HttpMethod = .patch

                    var queryParameters: [QueryParameter] {
                        [

                        ]
                    }

                    let body: BookPatch
                }

                extension PartialUpdateBook: HttpRequest {
                }
                """,
            macros: ["Patch": PatchMacro.self]
        )
    }

    func testPatchMacroWithExistingBodyProperty() {
        assertMacroExpansion(
            """
            @Patch("/books/1")
            struct PartialUpdateBook {
                let body: String = "existing body"
            }
            """,
            expandedSource: """
                struct PartialUpdateBook {
                    let body: String = "existing body"

                    let path: String = "/books/1"

                    let method: HttpMethod = .patch

                    var queryParameters: [QueryParameter] {
                        [

                        ]
                    }
                }

                extension PartialUpdateBook: HttpRequest {
                }
                """,
            macros: ["Patch": PatchMacro.self]
        )
    }
}
