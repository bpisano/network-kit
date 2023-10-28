//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 14/08/2023.
//

import XCTest
import NetworkKit

final class HttpRequestAccessTokenTests: XCTestCase {
    func testValidAccessToken() async throws {
        let accessTokenProvider: TestAccessTokenProvider = .init(accessToken: TestAccessTokenProvider.validAccessToken)
        let client: TestClient = .init(accessTokenProvider: accessTokenProvider)
        try await client.perform(.getPrivate)
    }

    func testInvalidAccessToken() async throws {
        let accessTokenProvider: TestAccessTokenProvider = .init()
        let client: TestClient = .init(accessTokenProvider: accessTokenProvider)
        await AsyncAssertThrowsError(try await client.perform(.getPrivate), handleError: { error in
            guard let error = error as? ResponseCode else {
                XCTFail("Invalid error type.")
                return
            }
            XCTAssertEqual(error, ResponseCode.forbidden)
        })
    }

    func testRefreshAccessToken() async throws {
        let accessTokenProvider: TestAccessTokenProvider = .init()
        accessTokenProvider.onRefreshAccessToken = { TestAccessTokenProvider.validAccessToken }
        let client: TestClient = .init(accessTokenProvider: accessTokenProvider)
        try await client.perform(.getPrivate)
    }

    func testFailRefreshAccessToken() async throws {
        let accessTokenProvider: TestAccessTokenProvider = .init()
        accessTokenProvider.onRefreshAccessToken = { throw TestError.refreshTokenFailed }
        let client: TestClient = .init(accessTokenProvider: accessTokenProvider)
        await AsyncAssertThrowsError(try await client.perform(.getPrivate), handleError: { error in
            guard let error = error as? TestError else {
                XCTFail("Invalid error type.")
                return
            }
            XCTAssertEqual(error, TestError.refreshTokenFailed)
        })
    }
}

extension HttpRequestAccessTokenTests {
    private enum TestError: Error {
        case refreshTokenFailed
    }
}
