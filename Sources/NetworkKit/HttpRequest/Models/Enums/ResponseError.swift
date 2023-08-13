//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 09/08/2023.
//

import Foundation

enum ResponseError: Int, LocalizedError {
    case internalServerError = 500
    case unknown = 0
    
    static func from(statusCode: Int) -> ResponseError {
        ResponseError(rawValue: statusCode) ?? .unknown
    }
    
    var errorDescription: String? {
        switch self {
        case .internalServerError:
            return "An error occured on the server."
        case .unknown:
            return "An unknown error occured."
        }
    }
}
