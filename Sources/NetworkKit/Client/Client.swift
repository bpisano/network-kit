//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 07/08/2023.
//

import Foundation

/// A protocol that represents a client that can perform any requests that conforms to the ``HttpRequest`` protocol.
public protocol Client {
    /// The scheme used for communication with the client. Defaults to `https`.
    var scheme: String { get }
    /// The base URL of the server you want to reach, excluding the request path.
    /// Example: `api.github.com`
    var host: String { get }
    /// The port number used for communication with the client. Defaults to `nil`.
    var port: Int? { get }
    /// An object responsible for managing access tokens and refreshing them when needed. Must conform to the ``AccessTokenProvider`` protocol.
    var accessTokenProvider: AccessTokenProvider? { get }
    /// The JSON decoder used for decoding data responses.
    var jsonDecoder: JSONDecoder { get }
    /// An object responsible to handle client logs.
    var logger: ClientLogger? { get }
}

public extension Client {
    var scheme: String { "https" }
    var port: Int? { nil }
    var accessTokenProvider: AccessTokenProvider? { nil }
    var jsonDecoder: JSONDecoder { .init() }
    var logger: ClientLogger? { .default(identifier: host) }

    func perform<T: Decodable>(
        _ request: some HttpRequest,
        onProgress: ((_ progress: Progress) -> Void)? = nil
    ) async throws -> T {
        let data: Data = try await send(request, onProgress: onProgress)
        return try jsonDecoder.decode(T.self, from: data)
    }

    func performRaw(
        _ request: some HttpRequest,
        onProgress: ((_ progress: Progress) -> Void)? = nil
    ) async throws -> Data {
        try await send(request, onProgress: onProgress)
    }

    func perform(
        _ request: some HttpRequest,
        onProgress: ((_ progress: Progress) -> Void)? = nil
    ) async throws {
        try await send(request, onProgress: onProgress)
    }
    
    @discardableResult
    private func send(
        _ request: some HttpRequest,
        context: HttpRequestContext = .init(),
        onProgress: ((_ progress: Progress) -> Void)? = nil
    ) async throws -> Data {
        logger?.logProgress(request: request, from: self)
        let performer: HttpRequestPerformer = .init(client: self)
        let handler: HttpRequestResultHandler = .init()
        let (data, response) = try await performer.perform(request, onProgress: onProgress)
        let behavior: ResultBehavior = handler.handle(response: response, data: data, for: request)
        switch behavior {
        case let .throwError(error):
            logger?.logError(receivedData: data, for: request, from: self)
            throw error
        case let .decodeData(data):
            logger?.logSuccess(receivedData: data, for: request, from: self)
            return data
        case .refreshAccessToken:
            if let accessTokenProvider, context.shouldRetryOnFail {
                logger?.logRefreshToken(receivedData: data, for: request, from: self)
                try await accessTokenProvider.refreshAccessToken()
                return try await send(request, context: .init(shouldRetryOnFail: false))
            }
            logger?.logError(receivedData: data, for: request, from: self)
            throw ResponseCode(rawValue: response.statusCode) ?? ClientError.refreshAccessTokenFailed
        }
    }
}
