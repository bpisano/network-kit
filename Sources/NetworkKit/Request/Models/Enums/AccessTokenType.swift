//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 07/08/2023.
//

import Foundation

/// An enum representing the way an access token should be formatted in the request header.
public enum AccessTokenType {
    case none
    case bearer
    
    public func header(withToken token: String) -> String? {
        switch self {
        case .bearer:
            return "bearer \(token)"
        default:
            return nil
        }
    }
}
