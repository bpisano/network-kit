//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 11/08/2023.
//

import Foundation

struct MethodModifier: RequestModifier {
    func build(
        request: inout URLRequest,
        httpRequest: some HttpRequest,
        server: Server
    ) throws {
        request.httpMethod = httpRequest.method.rawValue.capitalized
    }
}

extension RequestModifier where Self == MethodModifier {
    static var method: Self {
        .init()
    }
}
