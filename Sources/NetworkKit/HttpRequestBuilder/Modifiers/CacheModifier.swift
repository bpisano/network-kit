//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 11/08/2023.
//

import Foundation

struct CacheModifier: RequestModifier {
    func build(
        request: inout URLRequest,
        httpRequest: some HttpRequest,
        server: Server
    ) throws {
        request.cachePolicy = httpRequest.cachePolicy
    }
}

extension RequestModifier where Self == CacheModifier {
    static var cache: Self {
        .init()
    }
}
