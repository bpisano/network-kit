//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 13/08/2023.
//

import Foundation
import NetworkKit

struct TestClient: Client {
    let scheme: String = "http"
    let host: String = "localhost"
    let port: Int? = 3000
    let accessTokenProvider: AccessTokenProvider?

    init(accessTokenProvider: AccessTokenProvider? = nil) {
        self.accessTokenProvider = accessTokenProvider
    }
}
