//
//  File.swift
//
//
//  Created by Benjamin Pisano on 14/08/2023.
//

import XCTest
import NetworkKit

final class HttpRequestTests: XCTestCase {
    func testSuccessfulRequest() async throws {
        let client: TestClient = .init()
        let users: [User] = try await client.perform(.getUsers)
        XCTAssertEqual(users.count, 3)
    }

    func testErrorRequest() async throws {
        let client: TestClient = .init()
        await AsyncAssertThrowsError(try await client.perform(.getError), handleError: { error in
            guard let error = error as? GetErrorRequest.RequestError else {
                XCTFail("Invalid error type.")
                return
            }
            XCTAssertEqual(error, GetErrorRequest.RequestError.internalServerError)
        })
    }

    func testQueryParametersRequest() async throws {
        let client: TestClient = .init()
        let userId: String = "user_id"
        let user: User = try await client.perform(.getUser(withId: userId))
        XCTAssertEqual(user.id, userId)
    }

    func testBodyRequest() async throws {
        let client: TestClient = .init()
        let userToCreate: User = .mock()
        let createdUser: User = try await client.perform(.createUser(userToCreate))
        XCTAssertEqual(createdUser, userToCreate)
    }

    func testBodyDictionaryRequest() async throws {
        let client: TestClient = .init()
        let userToCreate: User = .mock()
        let createdUser: User = try await client.perform(.createUserDictionary(userToCreate))
        XCTAssertEqual(createdUser, userToCreate)
    }
}
