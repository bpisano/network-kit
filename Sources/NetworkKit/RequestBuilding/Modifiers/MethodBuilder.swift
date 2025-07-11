//
//  MethodBuilder.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

struct MethodBuilder: RequestModifier {
    let method: HttpMethod

    func modify(_ request: inout URLRequest) {
        request.httpMethod = method.rawValue
    }
}
