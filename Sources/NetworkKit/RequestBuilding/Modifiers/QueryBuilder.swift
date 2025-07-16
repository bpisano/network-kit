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
        try request.queryParameters.forEach { queryParameter in
            try queryParameter.modify(&urlRequest)
        }
    }
}
