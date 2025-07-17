//
//  TimeoutBuilderTests.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 17/07/2025.
//

import Foundation
import Testing

@testable import NetworkKit

@Suite("Timeout Builder")
struct TimeoutBuilderTests {
    @Test
    func testTimeoutBuilderWithPositiveTimeout() throws {
        let timeoutBuilder = TimeoutBuilder(timeout: 30.0)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        try timeoutBuilder.modify(&urlRequest)

        #expect(urlRequest.timeoutInterval == 30.0)
    }

    @Test
    func testTimeoutBuilderOverwritesExistingTimeout() throws {
        let timeoutBuilder = TimeoutBuilder(timeout: 45.0)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        // Set an existing timeout
        urlRequest.timeoutInterval = 60.0

        try timeoutBuilder.modify(&urlRequest)

        #expect(urlRequest.timeoutInterval == 45.0)
    }

    @Test
    func testTimeoutBuilderPreservesOtherProperties() throws {
        let timeoutBuilder = TimeoutBuilder(timeout: 25.0)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        // Set other properties
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData

        try timeoutBuilder.modify(&urlRequest)

        #expect(urlRequest.timeoutInterval == 25.0)
        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.cachePolicy == .reloadIgnoringLocalCacheData)
    }
}
