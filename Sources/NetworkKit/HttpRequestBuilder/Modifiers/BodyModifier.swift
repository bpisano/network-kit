//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 11/08/2023.
//

import Foundation

struct BodyModifier: RequestModifier {
    func build(
        request: inout URLRequest,
        httpRequest: HttpRequest,
        server: Server
    ) throws {
        guard let body = httpRequest.body else { return }
        request.httpBody = try httpRequest.jsonEncoder.encode(body)
    }
}

extension RequestModifier where Self == BodyModifier {
    static var body: Self {
        .init()
    }
}
