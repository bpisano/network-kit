//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 11/08/2023.
//

import Foundation

struct HttpRequestBuilder {
    private let modifiers: [RequestModifier]
    
    init() {
        modifiers = []
    }
    
    private init(modifiers: [RequestModifier]) {
        self.modifiers = modifiers
    }
    
    func using(_ modifier: RequestModifier) -> Self {
        .init(modifiers: modifiers + [modifier])
    }
    
    func buildRequest(from httpRequest: Request, server: Server) throws -> URLRequest {
        var request: URLRequest = .init()
        for modifier in modifiers {
            try modifier.build(
                request: &request,
                httpRequest: httpRequest,
                server: server
            )
        }
        return request
    }
}
