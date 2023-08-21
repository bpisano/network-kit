//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 07/08/2023.
//

import Foundation

/// An enum representing how a request failure should be handled by a `Server`.
public enum RequestFailureBehavior {
    /// Use the default behavior of the server.
    case `default`
    /// Throw a custom error that can be handled in the server `perform` return.
    case throwError(_ error: Error)
    /// Ask the server to refresh the access token and perform the request again.
    case refreshAccessToken
}
