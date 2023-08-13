import XCTest
import NetworkKit

final class NetworkKitTests: XCTestCase {
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

    func testValidAccessToken() async throws {
        let accessTokenProvider: TestAccessTokenProvider = .init(accessToken: TestAccessTokenProvider.validAccessToken)
        let server: TestServer = .init(accessTokenProvider: accessTokenProvider)
        try await server.perform(.getPrivate)
    }
}
