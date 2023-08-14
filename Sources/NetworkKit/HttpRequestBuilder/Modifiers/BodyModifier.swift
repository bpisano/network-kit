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
        httpRequest: Request,
        server: Server
    ) throws {
        switch httpRequest {
        case let httpRequest as HttpRequest:
            guard let body = httpRequest.body else { return }
            request.httpBody = try httpRequest.jsonEncoder.encode(body)
        case let httpDataRequest as HttpDataRequest:
            request.httpBody = httpDataRequest.bodyData
        default:
            break
        }
    }
}

extension RequestModifier where Self == BodyModifier {
    static var body: Self {
        .init()
    }
}
