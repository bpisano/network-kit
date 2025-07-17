//
//  BodyBuilderTests.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 17/07/2025.
//

import Foundation
import Testing

@testable import NetworkKit

@Suite("Body Builder")
struct BodyBuilderTests {
    @Test
    func testBodyBuilderWithCodableBody() throws {
        let request = TestRequestWithCodableBody()
        let bodyBuilder = BodyBuilder(request: request, jsonEncoder: JSONEncoder())
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        try bodyBuilder.modify(&urlRequest)

        #expect(urlRequest.httpBody != nil)
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")

        let bodyData = try #require(urlRequest.httpBody)
        let decodedBody = try JSONDecoder().decode(TestBook.self, from: bodyData)
        #expect(decodedBody.title == "Test Book")
        #expect(decodedBody.author == "Test Author")
    }

    @Test
    func testBodyBuilderWithCustomEncoder() throws {
        let customEncoder = JSONEncoder()
        customEncoder.keyEncodingStrategy = .convertToSnakeCase
        customEncoder.dateEncodingStrategy = .iso8601

        let request = TestRequestWithDateBody()
        let bodyBuilder = BodyBuilder(request: request, jsonEncoder: customEncoder)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/events")!)

        try bodyBuilder.modify(&urlRequest)

        #expect(urlRequest.httpBody != nil)
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")

        let bodyData = try #require(urlRequest.httpBody)
        let jsonObject = try JSONSerialization.jsonObject(with: bodyData) as? [String: Any]
        #expect(jsonObject?["event_name"] as? String == "Test Event")
        #expect(jsonObject?["created_at"] != nil)
    }

    @Test
    func testBodyBuilderWithEmptyBody() throws {
        let request = TestRequestWithEmptyBody()
        let bodyBuilder = BodyBuilder(request: request, jsonEncoder: JSONEncoder())
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        try bodyBuilder.modify(&urlRequest)

        #expect(urlRequest.httpBody != nil)
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")

        let bodyData = try #require(urlRequest.httpBody)
        let jsonObject = try JSONSerialization.jsonObject(with: bodyData) as? [String: Any]
        #expect(jsonObject?.isEmpty == true)
    }

    @Test
    func testBodyBuilderWithArrayBody() throws {
        let request = TestRequestWithArrayBody()
        let bodyBuilder = BodyBuilder(request: request, jsonEncoder: JSONEncoder())
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        try bodyBuilder.modify(&urlRequest)

        #expect(urlRequest.httpBody != nil)
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")

        let bodyData = try #require(urlRequest.httpBody)
        let decodedBody = try JSONDecoder().decode([TestBook].self, from: bodyData)
        #expect(decodedBody.count == 2)
        #expect(decodedBody[0].title == "Book 1")
        #expect(decodedBody[1].title == "Book 2")
    }

    @Test
    func testBodyBuilderWithNestedBody() throws {
        let request = TestRequestWithNestedBody()
        let bodyBuilder = BodyBuilder(request: request, jsonEncoder: JSONEncoder())
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/library")!)

        try bodyBuilder.modify(&urlRequest)

        #expect(urlRequest.httpBody != nil)
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")

        let bodyData = try #require(urlRequest.httpBody)
        let decodedBody = try JSONDecoder().decode(TestLibrary.self, from: bodyData)
        #expect(decodedBody.name == "Test Library")
        #expect(decodedBody.books.count == 1)
        #expect(decodedBody.books[0].title == "Nested Book")
    }

    @Test
    func testBodyBuilderWithOptionalProperties() throws {
        let request = TestRequestWithOptionalBody()
        let bodyBuilder = BodyBuilder(request: request, jsonEncoder: JSONEncoder())
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/users")!)

        try bodyBuilder.modify(&urlRequest)

        #expect(urlRequest.httpBody != nil)
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")

        let bodyData = try #require(urlRequest.httpBody)
        let decodedBody = try JSONDecoder().decode(TestUser.self, from: bodyData)
        #expect(decodedBody.name == "Test User")
        #expect(decodedBody.email == "test@example.com")
        #expect(decodedBody.age == nil)
    }

    @Test
    func testBodyBuilderPreservesExistingHeaders() throws {
        let request = TestRequestWithCodableBody()
        let bodyBuilder = BodyBuilder(request: request, jsonEncoder: JSONEncoder())
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        // Set an existing header
        urlRequest.setValue("Bearer token123", forHTTPHeaderField: "Authorization")

        try bodyBuilder.modify(&urlRequest)

        #expect(urlRequest.httpBody != nil)
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer token123")
    }

    @Test
    func testBodyBuilderOverwritesContentType() throws {
        let request = TestRequestWithCodableBody()
        let bodyBuilder = BodyBuilder(request: request, jsonEncoder: JSONEncoder())
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        // Set an existing Content-Type header
        urlRequest.setValue("text/plain", forHTTPHeaderField: "Content-Type")

        try bodyBuilder.modify(&urlRequest)

        #expect(urlRequest.httpBody != nil)
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }
}

// MARK: - Test Request Types

@Post("/books")
private struct TestRequestWithCodableBody {
    let body = TestBook(title: "Test Book", author: "Test Author")
}

@Post("/events")
private struct TestRequestWithDateBody {
    let body = TestEvent(eventName: "Test Event", createdAt: Date())
}

@Post("/books")
private struct TestRequestWithEmptyBody {
    let body = TestEmptyBody()
}

@Post("/books")
private struct TestRequestWithArrayBody {
    let body = [
        TestBook(title: "Book 1", author: "Author 1"),
        TestBook(title: "Book 2", author: "Author 2"),
    ]
}

@Post("/library")
private struct TestRequestWithNestedBody {
    let body = TestLibrary(
        name: "Test Library",
        books: [TestBook(title: "Nested Book", author: "Nested Author")]
    )
}

@Post("/users")
private struct TestRequestWithOptionalBody {
    let body = TestUser(name: "Test User", email: "test@example.com", age: nil)
}

// MARK: - Test Body Types

private struct TestBook: HttpBody, Decodable {
    let title: String
    let author: String
}

private struct TestEvent: HttpBody, Decodable {
    let eventName: String
    let createdAt: Date
}

private struct TestEmptyBody: HttpBody, Decodable {
    // Empty body
}

private struct TestLibrary: HttpBody, Decodable {
    let name: String
    let books: [TestBook]
}

private struct TestUser: HttpBody, Decodable {
    let name: String
    let email: String
    let age: Int?
}
