//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 13/08/2023.
//

import Foundation
import NetworkKit

struct GetUserRequest: HttpRequest {
    let path: String = "/user"
    let queryParameters: HttpQueryParameters?

    init(id: String) {
        queryParameters = [
            "id": id
        ]
    }
}

extension Request where Self == GetUserRequest {
    static func getUser(withId id: String) -> Self {
        .init(id: id)
    }
}
