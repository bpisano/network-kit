//
//  CachePolicyBuilder.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

struct CachePolicyBuilder: RequestModifier, Sendable {
    let cachePolicy: URLRequest.CachePolicy

    func modify(_ urlRequest: inout URLRequest) throws {
        urlRequest.cachePolicy = cachePolicy
    }
}
