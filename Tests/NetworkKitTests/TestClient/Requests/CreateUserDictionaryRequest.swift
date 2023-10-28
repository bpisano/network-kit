//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 28/10/2023.
//

import Foundation
import NetworkKit

struct CreateUserDictionaryRequest: HttpRequest {
    let path: String = "/user"
    let method: HttpMethod = .post

    private let user: User

    init(user: User) {
        self.user = user
    }

    var body: some HttpBody {
        [
            "id": user.id,
            "username": user.username
        ]
    }
}

extension HttpRequest where Self == CreateUserDictionaryRequest {
    static func createUserDictionary(_ user: User) -> Self {
        .init(user: user)
    }
}
