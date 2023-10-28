//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 13/08/2023.
//

import Foundation
import NetworkKit

struct GetUsersRequest: HttpRequest {
    let path: String = "/users"
}

extension HttpRequest where Self == GetUsersRequest {
    static var getUsers: Self {
        .init()
    }
}
