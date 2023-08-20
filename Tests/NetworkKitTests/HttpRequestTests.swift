//
//  File.swift
//
//
//  Created by Benjamin Pisano on 14/08/2023.
//

import XCTest
import NetworkKit

final class HttpRequestTests: XCTestCase {
    func testSuccessfullRequest() async throws {
        let server: TestServer = .init()
        let users: [User] = try await server.perform(.getUsers)
        XCTAssertEqual(users.count, 3)
    }

    func testErrorRequest() async throws {
        let server: TestServer = .init()
        await AsyncAssertThrowsError(try await server.perform(.getError), handleError: { error in
            guard let error = error as? GetErrorRequest.RequestError else {
                XCTFail("Invalid error type.")
                return
            }
            XCTAssertEqual(error, GetErrorRequest.RequestError.internalServerError)
        })
    }

    func testQueryParamatersRequest() async throws {
        let server: TestServer = .init()
        let userId: String = "user_id"
        let user: User = try await server.perform(.getUser(withId: userId))
        XCTAssertEqual(user.id, userId)
    }

    func testBodyRequest() async throws {
        let server: TestServer = .init()
        let userToCreate: User = .mock()
        let createdUser: User = try await server.perform(.createUser(userToCreate))
        XCTAssertEqual(createdUser, userToCreate)
    }
}
