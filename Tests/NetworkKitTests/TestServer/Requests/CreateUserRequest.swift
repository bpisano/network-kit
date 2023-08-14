//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 13/08/2023.
//

import Foundation
import NetworkKit

struct CreateUserRequest: HttpRequest {
    let path: String = "/user"
    let method: HttpMethod = .post
    let body: Encodable?

    init(user: User) {
        body = user
    }
}

extension Request where Self == CreateUserRequest {
    static func createUser(_ user: User) -> Self {
        .init(user: user)
    }
}
