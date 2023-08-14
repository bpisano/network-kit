//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 14/08/2023.
//

import Foundation

public protocol Request {
    /// The path of the request that does not include the base.
    /// Example: `/login`
    var path: String { get }
    /// The HTTP method of the request. Default to `GET`.
    var method: HttpMethod { get }

    /// The headers of the request. Default to `nil`.
    var headers: HttpHeaders? { get }
    /// The query parameters of the request. Default to `nil`.
    var queryParameters: HttpQueryParameters? { get }

    /// The type of the access token. Default to `.none`.
    var accessTokenType: AccessTokenType { get }

    /// An array of status codes that are interpreted as a success for the server. Default to 200 and 201.
    var successStatusCodes: [Int] { get }
    /// A date formatter used to format date parameters.
    var dateFormatter: DateFormatter { get }
    /// The timeout of the request. Default to 5 seconds.
    var timeout: TimeInterval { get }
    /// The cache policy of the request. Default to `.reloadIgnoringLocalAndRemoteCacheData`.
    var cachePolicy: URLRequest.CachePolicy { get }

    func urlRequest(server: Server) throws -> URLRequest
    func failureBehavior(for statusCode: Int) -> FailureBehavior
}
