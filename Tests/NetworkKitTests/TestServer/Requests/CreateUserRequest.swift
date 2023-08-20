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

    private let user: User

    init(user: User) {
        self.user = user
    }

    var body: some HttpBody {
        Encode(user)
    }
}

extension HttpRequest where Self == CreateUserRequest {
    static func createUser(_ user: User) -> Self {
        .init(user: user)
    }
}
