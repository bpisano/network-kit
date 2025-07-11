//
//  BodyBuilder.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

struct BodyBuilder: RequestModifier {
    let request: any HttpRequest
    let jsonEncoder: JSONEncoder

    func modify(_ urlRequest: inout URLRequest) throws {
        try request.body.modify(&urlRequest, using: jsonEncoder)
    }
}
