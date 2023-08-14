//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 07/08/2023.
//

import Foundation

/// A protocol used to build an HTTP request.
public protocol HttpRequest: Request {
    /// The body of the request. Must conforms to `Encodable`.
    var body: Encodable? { get }
    /// A `JSONEncoder` used to encode the body of the request.
    var jsonEncoder: JSONEncoder { get }
}

public extension HttpRequest {
    var method: HttpMethod { .get }
    var queryParameters: HttpQueryParameters? { nil }
    var body: Encodable? { nil }
    var headers: HttpHeaders? { nil }
    var jsonEncoder: JSONEncoder { .init() }
    var accessTokenType: AccessTokenType { .none }
    var successStatusCodes: [Int] { [200, 201] }
    var dateFormatter: DateFormatter { .init() }
    var timeout: TimeInterval { 5 }
    var cachePolicy: URLRequest.CachePolicy { .reloadIgnoringLocalAndRemoteCacheData }

    func urlRequest(server: Server) throws -> URLRequest {
        try HttpRequestBuilder()
            .using(.method)
            .using(.queryParameters)
            .using(.body)
            .using(.headers)
            .using(.timeout)
            .using(.cache)
            .buildRequest(from: self, server: server)
    }

    func failureBehavior(for statusCode: Int) -> FailureBehavior {
        guard statusCode == 401 || statusCode == 403 else { return .default }
        return .refreshAccessToken
    }
}
