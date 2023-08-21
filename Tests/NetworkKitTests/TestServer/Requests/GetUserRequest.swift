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

    private let id: String

    init(id: String) {
        self.id = id
    }

    var headers: HttpHeaders? {
        HttpHeader("Test", value: "Hello")
        HttpHeader("Test", value: "Hello")
    }

    var queryParameters: HttpQueryParameters? {
        HttpQueryParameter("id", value: id)
    }
}

extension HttpRequest where Self == GetUserRequest {
    static func getUser(withId id: String) -> Self {
        .init(id: id)
    }
}
