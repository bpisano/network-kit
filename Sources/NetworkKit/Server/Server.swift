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

    func perform<T: Decodable>(
        _ request: some HttpRequest,
        onProgress: ((_ progress: Progress) -> Void)? = nil
    ) async throws -> T {
        let data: Data = try await send(request, onProgress: onProgress)
        return try decoder.decode(T.self, from: data)
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
        let performer: HttpRequestPerformer = .init(server: self)
        let handler: HttpRequestResultHandler = .init()
        let (data, response) = try await performer.perform(request, onProgress: onProgress)
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
            throw ResponseCode(rawValue: response.statusCode) ?? ServerError.refreshAccessTokenFailed
        }
    }
}
