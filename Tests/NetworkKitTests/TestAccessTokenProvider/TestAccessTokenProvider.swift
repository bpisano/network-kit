//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 13/08/2023.
//

import Foundation
import NetworkKit

final class TestAccessTokenProvider: AccessTokenProvider {
    static let validAccessToken: String = "valid_access_token"
    
    var accessToken: String?
    var onRefreshAccessToken: (() throws -> String)?

    init(accessToken: String? = nil) {
        self.accessToken = accessToken
    }

    func refreshAccessToken() async throws {
        accessToken = try onRefreshAccessToken?()
    }
}

extension AccessTokenProvider where Self == TestAccessTokenProvider {
    static func test(accessToken: String? = nil) -> Self {
        .init(accessToken: accessToken)
    }
}
