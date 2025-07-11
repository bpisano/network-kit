//
//  RequestBuilder.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

struct RequestBuilder {
    func build<Request: HttpRequest>(client: HttpClient, request: Request) throws -> URLRequest {
        let modifiers: [RequestModifier] = [
            PathBuilder(request: request),
            QueryBuilder(request: request),
            HeaderBuilder(request: request),
            BodyBuilder(request: request, jsonEncoder: client.encoder),
            MethodBuilder(method: request.method),
            TimeoutBuilder(timeout: request.timeout),
            CachePolicyBuilder(cachePolicy: request.cachePolicy),
        ]

        var urlRequest: URLRequest = .init(url: client.baseUrl.appendingPathComponent(request.path))
        try modifiers.forEach { try $0.modify(&urlRequest) }

        return urlRequest
    }
}
