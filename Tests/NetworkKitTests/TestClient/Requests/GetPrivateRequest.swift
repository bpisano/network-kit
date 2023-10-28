//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 13/08/2023.
//

import Foundation
import NetworkKit

struct GetPrivateRequest: HttpRequest {
    let path: String = "/private"
    let accessTokenType: AccessTokenType = .bearer
}

extension HttpRequest where Self == GetPrivateRequest {
    static var getPrivate: Self {
        .init()
    }
}
