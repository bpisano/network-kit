//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 07/08/2023.
//

import Foundation

/// An enum representing the way an access token should be formatted in the request header.
public enum AccessTokenType: Equatable, Hashable, Codable {
    /// No access token should be added to the request header.
    case none
    /// The access token should be formatted as a Bearer token in the request header.
    case bearer
    /// The access token should be formatted as a Basic token in the request header.
    case basic
    /// Initializes a custom access token type with the provided prefix.
    /// - Parameter prefix: The prefix to be added before the token value in the header.
    case custom(prefix: String)

    public func header(withToken token: String) -> String? {
        switch self {
        case .bearer:
            return "Bearer \(token)"
        case .basic:
            return "Basic \(token)"
        case .custom(let prefix):
            return "\(prefix) \(token)"
        default:
            return nil
        }
    }
}
