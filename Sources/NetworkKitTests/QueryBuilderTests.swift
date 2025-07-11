//
//  QueryBuilderTests.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation
import Testing

@testable import NetworkKit

@Suite("Query Builder")
struct QueryBuilderTests {
    @Test
    func testQueryBuilderWithSingleQueryParameter() throws {
        let request = TestRequestWithSingleQuery(search: "swift")
        let queryBuilder = QueryBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        try queryBuilder.modify(&urlRequest)

        #expect(urlRequest.url?.absoluteString == "https://api.example.com/books?search=swift")
    }

    @Test
    func testQueryBuilderWithMultipleQueryParameters() throws {
        let request = TestRequestWithMultipleQueries(category: "programming", author: "apple")
        let queryBuilder = QueryBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        try queryBuilder.modify(&urlRequest)

        #expect(
            urlRequest.url?.absoluteString
                == "https://api.example.com/books?category=programming&author=apple")
    }

    @Test
    func testQueryBuilderWithNoQueryParameters() throws {
        let request = TestRequestWithNoQueries()
        let queryBuilder = QueryBuilder(request: request)
        let originalURL = URL(string: "https://api.example.com/books")!
        var urlRequest = URLRequest(url: originalURL)

        try queryBuilder.modify(&urlRequest)

        #expect(urlRequest.url?.absoluteString == originalURL.absoluteString)
    }

    @Test
    func testQueryBuilderWithMixedProperties() throws {
        let request = TestRequestWithMixedProperties(category: "fiction")
        let queryBuilder = QueryBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        try queryBuilder.modify(&urlRequest)

        #expect(urlRequest.url?.absoluteString == "https://api.example.com/books?category=fiction")
    }

    @Test
    func testQueryBuilderWithEmptyQueryValue() throws {
        let request = TestRequestWithEmptyQuery(search: "")
        let queryBuilder = QueryBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        try queryBuilder.modify(&urlRequest)

        #expect(urlRequest.url?.absoluteString == "https://api.example.com/books?search=")
    }

    @Test
    func testQueryBuilderWithSpecialCharacters() throws {
        let request = TestRequestWithSpecialCharacters(query: "hello world")
        let queryBuilder = QueryBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/search")!)

        try queryBuilder.modify(&urlRequest)

        #expect(
            urlRequest.url?.absoluteString == "https://api.example.com/search?query=hello%20world")
    }

    @Test
    func testQueryBuilderWithNumericValues() throws {
        let request = TestRequestWithNumericValues(page: 1, limit: 10)
        let queryBuilder = QueryBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        try queryBuilder.modify(&urlRequest)

        #expect(urlRequest.url?.absoluteString == "https://api.example.com/books?page=1&limit=10")
    }

    @Test
    func testQueryBuilderWithBooleanValues() throws {
        let request = TestRequestWithBooleanValues(published: true, featured: false)
        let queryBuilder = QueryBuilder(request: request)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        try queryBuilder.modify(&urlRequest)

        #expect(
            urlRequest.url?.absoluteString
                == "https://api.example.com/books?published=true&featured=false")
    }
}

// MARK: - Test Request Types

@Get("/books")
private struct TestRequestWithSingleQuery {
    @Query
    var search: String
}

@Get("/books")
private struct TestRequestWithMultipleQueries {
    @Query
    var category: String

    @Query
    var author: String
}

@Get("/books")
private struct TestRequestWithNoQueries {
    let title = "Test Book"
    let description = "Test Description"
}

@Get("/books")
private struct TestRequestWithMixedProperties {
    @Query
    var category: String
}

@Get("/books")
private struct TestRequestWithEmptyQuery {
    @Query
    var search: String
}

@Get("/search")
private struct TestRequestWithSpecialCharacters {
    @Query
    var query: String
}

@Get("/books")
private struct TestRequestWithNumericValues {
    @Query
    var page: Int

    @Query
    var limit: Int
}

@Get("/books")
private struct TestRequestWithBooleanValues {
    @Query
    var published: Bool

    @Query
    var featured: Bool
}
