//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 07/08/2023.
//

import Foundation

/// An enum representing how a request failure should be handled by a ``Client``.
public enum RequestFailureBehavior: Sendable {
    /// Use the default behavior of the client.
    case `default`
    /// Throw a custom error that can be handled in the client `perform` return.
    case throwError(_ error: Error)
    /// Ask the client to refresh the access token and perform the request again.
    case refreshAccessToken
}
