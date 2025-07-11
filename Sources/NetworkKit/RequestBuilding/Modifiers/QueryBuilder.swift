//
//  QueryBuilder.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

struct QueryBuilder: RequestModifier {
    let request: any HttpRequest

    func modify(_ urlRequest: inout URLRequest) throws {
        let mirror: Mirror = .init(reflecting: request)
        for child in mirror.children {
            if let query = child.value as? QueryProtocol, let propertyName = child.label {
                let queryValue: String = query.queryValue
                let cleanPropertyName = String(propertyName.dropFirst())
                urlRequest.url = urlRequest.url?.appendingQueryParameter(
                    cleanPropertyName,
                    with: queryValue
                )
            }
        }
    }
}
