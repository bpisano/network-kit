//
//  CachePolicyBuilderTests.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 17/07/2025.
//

import Foundation
import Testing

@testable import NetworkKit

@Suite("Cache Policy Builder")
struct CachePolicyBuilderTests {
    @Test
    func testCachePolicyBuilderWithUseProtocolCachePolicy() throws {
        let cachePolicyBuilder = CachePolicyBuilder(cachePolicy: .useProtocolCachePolicy)
        var urlRequest = URLRequest(url: URL(string: "https://api.example.com/books")!)

        try cachePolicyBuilder.modify(&urlRequest)

        #expect(urlRequest.cachePolicy == .useProtocolCachePolicy)
    }
}
