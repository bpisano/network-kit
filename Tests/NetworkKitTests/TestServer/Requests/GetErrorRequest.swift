//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 13/08/2023.
//

import Foundation
import NetworkKit

struct GetErrorRequest: HttpRequest {
    let path: String = "/error"

    func failureBehavior(for statusCode: Int) -> RequestFailureBehavior {
        guard let error = RequestError(rawValue: statusCode) else { return .default }
        return .throwError(error)
    }
}

extension HttpRequest where Self == GetErrorRequest {
    static var getError: Self {
        .init()
    }
}

extension GetErrorRequest {
    enum RequestError: Int, LocalizedError {
        case internalServerError = 500

        var errorDescription: String? {
            return "Internal server error."
        }
    }
}
