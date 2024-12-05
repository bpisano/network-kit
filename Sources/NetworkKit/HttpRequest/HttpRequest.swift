//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 07/08/2023.
//

import Foundation

/// A protocol used to build an HTTP request.
public protocol HttpRequest: Sendable {
    associatedtype Body: HttpBody

    /// The path of the request that does not include the base.
    /// Example: `/login`
    var path: String { get }
    /// The HTTP method of the request. Default to `GET`.
    var method: HttpMethod { get }

    /// The headers of the request. Default to `nil`.
    @HttpHeadersBuilder
    var headers: HttpHeaders? { get }
    /// The query parameters of the request. Default to `nil`.
    @HttpQueryParametersBuilder
    var queryParameters: HttpQueryParameters? { get }
    /// The body of the request.
    var body: Body { get }

    /// A `JSONEncoder` used to encode the body of the request.
    var jsonEncoder: JSONEncoder { get }
    /// A date formatter used to format date parameters.
    var dateFormatter: DateFormatter { get }

    /// The type of the access token. Default to `.none`.
    var accessTokenType: AccessTokenType { get }

    /// An array of status codes that are interpreted as a success for the client. Default to 200 and 201.
    var successStatusCodes: [Int] { get }
    /// The timeout of the request. Default to 5 seconds.
    var timeout: TimeInterval { get }
    /// The cache policy of the request. Default to `.reloadIgnoringLocalAndRemoteCacheData`.
    var cachePolicy: URLRequest.CachePolicy { get }

    func urlRequest(client: Client) throws -> URLRequest
    func makeHeaders() -> HttpHeaders
    func encodeBody() throws -> Data?
    func failureBehavior(for statusCode: Int) -> RequestFailureBehavior
}

public extension HttpRequest {
    var method: HttpMethod { .get }

    var headers: HttpHeaders? { nil }
    var queryParameters: HttpQueryParameters? { nil }
    var body: some HttpBody { EmptyBody() }

    var jsonEncoder: JSONEncoder { .init() }
    var dateFormatter: DateFormatter { .init() }

    var accessTokenType: AccessTokenType { .none }

    var successStatusCodes: [Int] { [200, 201] }
    var timeout: TimeInterval { 5 }
    var cachePolicy: URLRequest.CachePolicy { .reloadIgnoringLocalAndRemoteCacheData }

    func urlRequest(client: Client) throws -> URLRequest {
        try HttpRequestBuilder()
            .using(.method)
            .using(.queryParameters)
            .using(.body)
            .using(.headers)
            .using(.timeout)
            .using(.cache)
            .buildRequest(from: self, client: client)
    }

    func failureBehavior(for statusCode: Int) -> RequestFailureBehavior {
        guard statusCode == 401 || statusCode == 403 else { return .default }
        return .refreshAccessToken
    }

    func makeHeaders() -> HttpHeaders {
        let bodyHeadersDictionary: [String: String]? = body.overrideHeaders?.dictionaryHeaders(dateFormatter: dateFormatter)
        let bodyHeaders: [String: String] = bodyHeadersDictionary ?? [String: String]()
        let headersDictionary: [String: String]? = headers?.dictionaryHeaders(dateFormatter: dateFormatter)
        let headers: [String: String] = headersDictionary ?? [String: String]()
        return headers.merging(bodyHeaders, uniquingKeysWith: { old, _ in old })
    }

    func encodeBody() throws -> Data? {
        try body.encode(using: jsonEncoder)
    }
}

public extension HttpRequest where Body == EmptyBody {
    func makeHeaders() -> HttpHeaders {
        headers?.dictionaryHeaders(dateFormatter: dateFormatter) ?? [String: String]()
    }

    func encodeBody() throws -> Data? {
        nil
    }
}
