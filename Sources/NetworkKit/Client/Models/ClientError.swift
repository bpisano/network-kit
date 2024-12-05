//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 12/08/2023.
//

import Foundation

public enum ClientError: Sendable, LocalizedError {
    case refreshAccessTokenFailed
    
    public var errorDescription: String? {
        switch self {
        case .refreshAccessTokenFailed:
            return "Failed to refresh access token."
        }
    }
}
