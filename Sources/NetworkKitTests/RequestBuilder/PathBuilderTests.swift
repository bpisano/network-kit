//
//  PathBuilderTests.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation
import Testing

@testable import NetworkKit

@Suite("Path Builder")
struct PathBuilderTests {
    @Test
    func testPathBuilderWithSinglePathParameter() throws {
        let request = TestRequestWithSinglePath(id: "123")
        let pathBuilder = PathBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books/:id")!)

        try pathBuilder.modify(&urlRequest)

        #expect(urlRequest.url?.absoluteString == "https://api.example.com/books/123")
    }

    @Test
    func testPathBuilderWithMultiplePathParameters() throws {
        let request = TestRequestWithMultiplePaths(userId: "456", bookId: "789")
        let pathBuilder = PathBuilder(request: request)
        var urlRequest = URLRequest(
            url: URL(string: "https://api.example.com/users/:userId/books/:bookId")!)

        try pathBuilder.modify(&urlRequest)

        #expect(urlRequest.url?.absoluteString == "https://api.example.com/users/456/books/789")
    }

    @Test
    func testPathBuilderWithNoPathParameters() throws {
        let request = TestRequestWithNoPaths()
        let pathBuilder = PathBuilder(request: request)
        let originalURL = URL(string: "https://api.example.com/books")!
        var urlRequest = URLRequest(url: originalURL)

        try pathBuilder.modify(&urlRequest)

        #expect(urlRequest.url?.absoluteString == originalURL.absoluteString)
    }

    @Test
    func testPathBuilderWithMixedProperties() throws {
        let request = TestRequestWithMultiplePaths(userId: "999", bookId: "dummy")
        let pathBuilder = PathBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/users/:userId")!)

        try pathBuilder.modify(&urlRequest)

        #expect(urlRequest.url?.absoluteString == "https://api.example.com/users/999")
    }

    @Test
    func testPathBuilderWithEmptyPathValue() throws {
        let request = TestRequestWithSinglePath(id: "")
        let pathBuilder = PathBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books/:id")!)

        try pathBuilder.modify(&urlRequest)

        #expect(urlRequest.url?.absoluteString == "https://api.example.com/books/")
    }

    @Test
    func testPathBuilderWithSpecialCharacters() throws {
        let request = TestRequestWithSinglePath(id: "hello%20world")
        let pathBuilder = PathBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/search/:id")!)

        try pathBuilder.modify(&urlRequest)

        #expect(urlRequest.url?.absoluteString == "https://api.example.com/search/hello%2520world")
    }
}

// MARK: - Test Request Types

@Get("/books/:id")
private struct TestRequestWithSinglePath {
    @Path
    var id: String
}

@Get("/users/:userId/books/:bookId")
private struct TestRequestWithMultiplePaths {
    @Path
    var userId: String

    @Path
    var bookId: String
}

@Get("/books")
private struct TestRequestWithNoPaths {
    let title = "Test Book"
    let author = "Test Author"
}
