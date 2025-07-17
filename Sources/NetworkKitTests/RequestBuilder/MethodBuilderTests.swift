//
//  MethodBuilderTests.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 17/07/2025.
//

import Foundation
import Testing

@testable import NetworkKit

@Suite("Method Builder")
struct MethodBuilderTests {
    @Test
    func testMethodBuilderOverwritesExistingMethod() throws {
        let methodBuilder = MethodBuilder(method: .post)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        // Set an existing method
        urlRequest.httpMethod = "GET"

        methodBuilder.modify(&urlRequest)

        #expect(urlRequest.httpMethod == "POST")
    }

    @Test
    func testMethodBuilderPreservesOtherProperties() throws {
        let methodBuilder = MethodBuilder(method: .post)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        // Set other properties
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = 30.0
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData

        methodBuilder.modify(&urlRequest)

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.timeoutInterval == 30.0)
        #expect(urlRequest.cachePolicy == .reloadIgnoringLocalCacheData)
    }

    @Test
    func testMethodBuilderWithAllHttpMethods() throws {
        let methods: [HttpMethod] = [
            .get, .post, .put, .patch, .delete, .options, .head, .trace, .connect,
        ]
        let expectedValues = [
            "GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS", "HEAD", "TRACE", "CONNECT",
        ]

        for (method, expectedValue) in zip(methods, expectedValues) {
            let methodBuilder = MethodBuilder(method: method)
            var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

            methodBuilder.modify(&urlRequest)

            #expect(urlRequest.httpMethod == expectedValue)
        }
    }
}
