//
//  HeaderBuilderTests.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation
import Testing

@testable import NetworkKit

@Suite("Header Builder")
struct HeaderBuilderTests {
    @Test
    func testHeaderBuilderWithSingleHeader() throws {
        let request = TestRequestWithSingleHeader()
        let headerBuilder = HeaderBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        try headerBuilder.modify(&urlRequest)

        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer token123")
    }

    @Test
    func testHeaderBuilderWithMultipleHeaders() throws {
        let request = TestRequestWithMultipleHeaders()
        let headerBuilder = HeaderBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        try headerBuilder.modify(&urlRequest)

        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer token123")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
    }

    @Test
    func testHeaderBuilderWithNoHeaders() throws {
        let request = TestRequestWithNoHeaders()
        let headerBuilder = HeaderBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)
        let originalHeaders = urlRequest.allHTTPHeaderFields

        try headerBuilder.modify(&urlRequest)

        #expect(urlRequest.allHTTPHeaderFields == originalHeaders)
    }

    @Test
    func testHeaderBuilderWithEmptyHeaderValue() throws {
        let request = TestRequestWithEmptyHeader()
        let headerBuilder = HeaderBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        try headerBuilder.modify(&urlRequest)

        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "")
    }

    @Test
    func testHeaderBuilderWithNilHeaderValue() throws {
        let request = TestRequestWithNilHeader()
        let headerBuilder = HeaderBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        try headerBuilder.modify(&urlRequest)

        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == nil)
    }

    @Test
    func testHeaderBuilderWithSpecialCharacters() throws {
        let request = TestRequestWithSpecialCharacters()
        let headerBuilder = HeaderBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        try headerBuilder.modify(&urlRequest)

        #expect(urlRequest.value(forHTTPHeaderField: "User-Agent") == "My App/1.0 (iOS 15.0)")
    }

    @Test
    func testHeaderBuilderWithNumericValues() throws {
        let request = TestRequestWithNumericValues()
        let headerBuilder = HeaderBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        try headerBuilder.modify(&urlRequest)

        #expect(urlRequest.value(forHTTPHeaderField: "Content-Length") == "1024")
    }

    @Test
    func testHeaderBuilderWithCustomHeaderKeys() throws {
        let request = TestRequestWithCustomHeaderKeys()
        let headerBuilder = HeaderBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        try headerBuilder.modify(&urlRequest)

        #expect(urlRequest.value(forHTTPHeaderField: "X-Custom-Header") == "custom value")
    }

    @Test
    func testHeaderBuilderWithCaseSensitiveHeaders() throws {
        let request = TestRequestWithCaseSensitiveHeaders()
        let headerBuilder = HeaderBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        try headerBuilder.modify(&urlRequest)

        #expect(urlRequest.value(forHTTPHeaderField: "AUTHORIZATION") == "Bearer token123")
    }

    @Test
    func testHeaderBuilderOverwritesExistingHeaders() throws {
        let request = TestRequestWithSingleHeader()
        let headerBuilder = HeaderBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        // Set an existing header
        urlRequest.setValue("Bearer oldToken", forHTTPHeaderField: "Authorization")

        try headerBuilder.modify(&urlRequest)

        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer token123")
    }

    @Test
    func testHeaderBuilderWithMixedHeaders() throws {
        let request = TestRequestWithMixedHeaders()
        let headerBuilder = HeaderBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        try headerBuilder.modify(&urlRequest)

        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer token123")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
    }
}

// MARK: - Test Request Types

@Get("/books")
private struct TestRequestWithSingleHeader {
    let headers: [String: String?] = ["Authorization": "Bearer token123"]
}

@Get("/books")
private struct TestRequestWithMultipleHeaders {
    let headers: [String: String?] = [
        "Authorization": "Bearer token123",
        "Content-Type": "application/json",
        "Accept": "application/json",
    ]
}

@Get("/books")
private struct TestRequestWithNoHeaders {
    let headers: [String: String?] = [:]
}

@Get("/books")
private struct TestRequestWithEmptyHeader {
    let headers: [String: String?] = ["Authorization": ""]
}

@Get("/books")
private struct TestRequestWithNilHeader {
    let headers: [String: String?] = ["Authorization": nil]
}

@Get("/books")
private struct TestRequestWithSpecialCharacters {
    let headers: [String: String?] = ["User-Agent": "My App/1.0 (iOS 15.0)"]
}

@Get("/books")
private struct TestRequestWithNumericValues {
    let headers: [String: String?] = ["Content-Length": "1024"]
}

@Get("/books")
private struct TestRequestWithCustomHeaderKeys {
    let headers: [String: String?] = ["X-Custom-Header": "custom value"]
}

@Get("/books")
private struct TestRequestWithCaseSensitiveHeaders {
    let headers: [String: String?] = ["AUTHORIZATION": "Bearer token123"]
}

@Get("/books")
private struct TestRequestWithMixedHeaders {
    let headers: [String: String?] = [
        "Authorization": "Bearer token123",
        "Content-Type": nil,
    ]
}
