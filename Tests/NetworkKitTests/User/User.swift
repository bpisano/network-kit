//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 13/08/2023.
//

import Foundation

struct User: Equatable, Codable {
    let id: String
    let username: String

    static func mock(
        id: String = "user_id",
        username: String = "John Doe"
    ) -> User {
        .init(
            id: id,
            username: username
        )
    }
}
