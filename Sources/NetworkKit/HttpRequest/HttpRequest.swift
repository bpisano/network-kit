//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 07/08/2023.
//

import Foundation

/// A protocol used to build an HTTP request.
public protocol HttpRequest {
    /// The path of the request that does not include the base.
    /// Example: `/login`
    var path: String { get }
    /// The HTTP method of the request. Default to `GET`.
    var method: HttpMethod { get }
    
    /// The parameters of the request. Default to `nil`.
    var queryParameters: HttpQueryParameters? { get }
    var body: Encodable? { get }
    /// The headers of the request. Default to `nil`.
    var headers: HttpHeaders? { get }
    var jsonEncoder: JSONEncoder { get }
    
    /// The type of the access token. Default to `.none`.
    var accessTokenType: AccessTokenType { get }
    
    var successStatusCodes: [Int] { get }
    var dateFormatter: DateFormatter { get }
    var timeout: TimeInterval { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    
    func failureBehavior(for statusCode: Int) -> FailureBehavior
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

    func failureBehavior(for statusCode: Int) -> FailureBehavior {
        guard statusCode == 401 || statusCode == 403 else { return .default }
        return .refreshAccessToken
    }
    
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
}
