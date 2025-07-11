//
//  PathBuilder.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

struct PathBuilder: RequestModifier {
    let request: any HttpRequest

    func modify(_ urlRequest: inout URLRequest) throws {
        let mirror: Mirror = .init(reflecting: request)
        for child in mirror.children {
            if let path = child.value as? Path, let propertyName = child.label {
                let pathValue: String = path.wrappedValue
                let cleanPropertyName = String(propertyName.dropFirst())
                urlRequest.url = urlRequest.url?.replacingPathParameter(
                    cleanPropertyName,
                    with: pathValue
                )
            }
        }
    }
}
