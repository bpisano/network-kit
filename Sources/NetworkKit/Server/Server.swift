//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 07/08/2023.
//

import Foundation

/// A protocol that represents a server that can perform any requests that conforms to the ``HttpRequest`` protocol.
public protocol Server {
    /// The scheme of the server. Default to `https`.
    var scheme: String { get }
    /// The base url of the server that doesn't include the path of a request.
    /// Example: `api.github.com`
    var host: String { get }
    /// The port of the server. Default to `nil`.
    var port: Int? { get }
    /// An object responsible of storing the access token and refreshing it. Must conforms to the ``AccessTokenProvider`` protocol.
    var accessTokenProvider: AccessTokenProvider? { get }
    /// The decoder for the data responses.
    var decoder: JSONDecoder { get }
//    /// An object responsible to handle server logs.
//    var logger: ServerLogger? { get }
}

public extension Server {
    var scheme: String { "https" }
    var port: Int? { nil }
    var accessTokenProvider: AccessTokenProvider? { nil }
    var decoder: JSONDecoder { .datefns }
//    var logger: ServerLogger? { NKServerLogger() }

    func perform<T: Decodable>(_ request: some HttpRequest) async throws -> T {
        let data: Data = try await send(request)
        return try decoder.decode(T.self, from: data)
    }

    func performRaw(_ request: some HttpRequest) async throws -> Data {
        try await send(request)
    }

    func perform(_ request: some HttpRequest) async throws {
        try await send(request)
    }
    
    @discardableResult
    private func send(_ request: some HttpRequest, context: HttpRequestContext = .init()) async throws -> Data {
        let performer: HttpRequestPerformer = .init(server: self)
        let handler: HttpRequestResultHandler = .init()
        let (data, response) = try await performer.perform(request)
        let behavior: ResultBehavior = handler.handle(response: response, data: data, for: request)
        switch behavior {
        case let .throwError(error):
            throw error
        case let .decodeData(data):
            return data
        case .refreshAccessToken:
            if let accessTokenProvider, context.shouldRetryOnFail {
                try await accessTokenProvider.refreshAccessToken()
                return try await send(request, context: .init(shouldRetryOnFail: false))
            }
            throw ResponseError(rawValue: response.statusCode) ?? ServerError.refreshAccessTokenFailed
        }
    }
    // Perform a request and decode its result to a given return type.
    /// - Parameter request: Any object that conforms to the ``HttpRequest`` protocol.
    /// - Returns: The result of the request.
//    func perform<T: Decodable>(request: HttpRequest) async throws -> T {
//        if let accessTokenProvider, request.accessTokenType != .none {
//            return try await execute(request: request, accessTokenProvider: accessTokenProvider)
//        }
//        return try await execute(request: request)
//    }
//
//    /// Perform a request.
//    /// - Parameter request: Any object that conforms to the ``HttpRequest`` protocol.
//    func perform(request: HttpRequest) async throws {
//        if let accessTokenProvider, request.accessTokenType != .none {
//            let _: Empty = try await execute(request: request, accessTokenProvider: accessTokenProvider)
//            return
//        }
//        let _: Empty = try await execute(request: request)
//    }
//
//    private func execute<T: Decodable>(request: HttpRequest) async throws -> T {
//        if let dataRequest = request.dataRequest(server: self, additionalHeaders: nil) {
//            return try await send(dataRequest: dataRequest, for: request)
//        }
//        throw ServerError.invalidRequest(request)
//    }
//
//    private func execute<T: Decodable>(
//        request: some HttpRequest,
//        accessTokenProvider: AccessTokenProvider,
//        retryIfNeeded: Bool = true
//    ) async throws -> T {
//        let accessToken: String = accessTokenProvider.accessToken ?? ""
//        let accessTokenHeaderValue: String = request.accessTokenType.header(withToken: accessToken)
//        let accessTokenHeader: HTTPHeader = HTTPHeader(name: "authorization", value: accessTokenHeaderValue)
//        let additionalHeaders: HTTPHeaders = HTTPHeaders(arrayLiteral: accessTokenHeader)
//        if let dataRequest = request.dataRequest(server: self, additionalHeaders: additionalHeaders) {
//            return try await send(
//                dataRequest: dataRequest,
//                for: request,
//                accessTokenProvider: accessTokenProvider,
//                retryIfNeeded: retryIfNeeded
//            )
//        }
//        throw ServerError.invalidRequest(request)
//    }
//
//    private func send<T: Decodable>(
//        request: HttpRequest,
//        with accessTokenProvider: AccessTokenProvider? = nil,
//        retryIfNeeded: Bool = true
//    ) async throws -> T {
//        let urlRequest: URLRequest = try request.urlRequest(server: self)
//        let (data, response) = try await URLSession.shared.data(for: urlRequest)
//        if let response = response as? HTTPURLResponse {
//
//        }
//
//
//
//        if let value = response.value {
//            return value
//        }
//
//        let canRefreshAccessToken: Bool = retryIfNeeded && request.refreshTokenOnFail
//        if let accessTokenProvider, let responseCode = response.error?.responseCode,
//           responseCode == request.refreshTokenStatusCode && canRefreshAccessToken
//        {
//            try await accessTokenProvider.refreshAccessToken()
//            return try await execute(
//                request: request,
//                accessTokenProvider: accessTokenProvider,
//                retryIfNeeded: false
//            )
//        }
//
//        if let mappedError = getError(fromRequest: request, responseError: response.error) {
//            throw mappedError
//        } else {
//            throw ServerError.unknown
//        }
//    }
//
//    private func handleError(with response: HTTPURLResponse)
//
//    private func getError(fromRequest request: HttpRequest, responseError: AFError?) -> Error? {
//        guard let statusCode = responseError?.responseCode else { return responseError }
//        if let mappedError = request.error(forStatusCode: statusCode) {
//            return mappedError
//        } else if let requestError = RequestError(rawValue: statusCode) {
//            return requestError
//        } else {
//            return responseError
//        }
//    }
}


