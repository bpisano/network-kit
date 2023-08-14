//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 14/08/2023.
//

import XCTest
import NetworkKit

final class RefreshAccessTokenTests: XCTestCase {
    func testValidAccessToken() async throws {
        let accessTokenProvider: TestAccessTokenProvider = .init(accessToken: TestAccessTokenProvider.validAccessToken)
        let server: TestServer = .init(accessTokenProvider: accessTokenProvider)
        try await server.perform(.getPrivate)
    }

    func testInvalidAccessToken() async throws {
        let accessTokenProvider: TestAccessTokenProvider = .init()
        let server: TestServer = .init(accessTokenProvider: accessTokenProvider)
        await AsyncAssertThrowsError(try await server.perform(.getPrivate), handleError: { error in
            guard let error = error as? ResponseError else {
                XCTFail("Invalid error type.")
                return
            }
            XCTAssertEqual(error, ResponseError.forbidden)
        })
    }

    func testRefreshAccessToken() async throws {
        let accessTokenProvider: TestAccessTokenProvider = .init()
        accessTokenProvider.onRefreshAccessToken = { TestAccessTokenProvider.validAccessToken }
        let server: TestServer = .init(accessTokenProvider: accessTokenProvider)
        try await server.perform(.getPrivate)
    }

    func testFailRefreshAccessToken() async throws {
        let accessTokenProvider: TestAccessTokenProvider = .init()
        accessTokenProvider.onRefreshAccessToken = { throw TestError.refreshTokenFailed }
        let server: TestServer = .init(accessTokenProvider: accessTokenProvider)
        await AsyncAssertThrowsError(try await server.perform(.getPrivate), handleError: { error in
            guard let error = error as? TestError else {
                XCTFail("Invalid error type.")
                return
            }
            XCTAssertEqual(error, TestError.refreshTokenFailed)
        })
    }
}

extension RefreshAccessTokenTests {
    private enum TestError: Error {
        case refreshTokenFailed
    }
}
