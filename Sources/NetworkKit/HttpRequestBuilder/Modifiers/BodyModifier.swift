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
        httpRequest: some HttpRequest,
        server: Server
    ) throws {
        request.httpBody = try httpRequest.encodeBody()
    }
}

extension RequestModifier where Self == BodyModifier {
    static var body: Self {
        .init()
    }
}
