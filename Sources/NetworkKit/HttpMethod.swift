//
//  HttpMethod.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

/// Represents the standard HTTP methods used in network requests.
///
/// This enum provides type-safe access to all standard HTTP methods defined in RFC 7231
/// and other relevant RFCs. Each case corresponds to a specific HTTP method with its
/// standard string representation.
///
/// ## Usage
///
/// ```swift
/// let request = MyRequest()
/// request.method = .get  // Sets the HTTP method to GET
/// ```
///
/// ## Available Methods
///
/// - `.get`: Retrieves a representation of the specified resource
/// - `.post`: Submits data to be processed to the specified resource
/// - `.put`: Replaces all current representations of the target resource
/// - `.patch`: Applies partial modifications to a resource
/// - `.delete`: Removes the specified resource
/// - `.options`: Describes the communication options for the target resource
/// - `.head`: Same as GET but transfers the status line and header section only
/// - `.trace`: Performs a message loop-back test along the path to the target resource
/// - `.connect`: Establishes a tunnel to the server identified by the target resource
public enum HttpMethod: String, CaseIterable, Hashable, Equatable, Sendable {
    /// HTTP GET method - retrieves a representation of the specified resource
    case get = "GET"
    /// HTTP POST method - submits data to be processed to the specified resource
    case post = "POST"
    /// HTTP PUT method - replaces all current representations of the target resource
    case put = "PUT"
    /// HTTP PATCH method - applies partial modifications to a resource
    case patch = "PATCH"
    /// HTTP DELETE method - removes the specified resource
    case delete = "DELETE"
    /// HTTP OPTIONS method - describes the communication options for the target resource
    case options = "OPTIONS"
    /// HTTP HEAD method - same as GET but transfers the status line and header section only
    case head = "HEAD"
    /// HTTP TRACE method - performs a message loop-back test along the path to the target resource
    case trace = "TRACE"
    /// HTTP CONNECT method - establishes a tunnel to the server identified by the target resource
    case connect = "CONNECT"
}
