//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 11/08/2023.
//

import Foundation

struct HttpRequestResultHandler {
    func handle(response: HTTPURLResponse, data: Data, for request: HttpRequest) -> ResultBehavior {
        let hasRequestSucceded: Bool = request.successStatusCodes.contains(response.statusCode)
        if hasRequestSucceded {
            return .decodeData(data)
        }
        
        let failureBehavior: FailureBehavior = request.failureBehavior(for: response.statusCode)
        switch failureBehavior {
        case .refreshAccessToken:
            return .refreshAccessToken
        case let .throwError(error):
            return .throwError(error)
        case .default:
            if let error = ResponseError(rawValue: response.statusCode) {
                return .throwError(error)
            }
            return .throwError(ResponseError.unknown)
        }
    }
}
