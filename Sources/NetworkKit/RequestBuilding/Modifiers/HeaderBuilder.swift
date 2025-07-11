//
//  HeaderBuilder.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

struct HeaderBuilder: RequestModifier {
    let request: any HttpRequest

    func modify(_ urlRequest: inout URLRequest) throws {
        for (key, value) in request.headers {
            if let headerValue = value {
                urlRequest.setValue(headerValue, forHTTPHeaderField: key)
            }
        }
    }
}
