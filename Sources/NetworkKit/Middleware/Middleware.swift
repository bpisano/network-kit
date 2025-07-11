//
//  Middleware.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

/// A protocol that defines middleware for modifying HTTP requests before they are sent.
///
/// Middleware provides a way to intercept and modify requests at various stages of
/// the request lifecycle. Common use cases include adding authentication headers,
/// logging, request transformation, and validation.
///
/// ## Usage
///
/// ```swift
/// struct AuthenticationMiddleware: Middleware {
///     let token: String
///
///     func modify(request: inout URLRequest) async throws {
///         request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
///     }
/// }
///
/// // Add middleware to a client
/// var client = Client("https://api.example.com")
/// client.middlewares = [AuthenticationMiddleware(token: "your-token")]
/// ```
///
/// ## Middleware Execution Order
///
/// Middleware is executed in the order they appear in the client's `middlewares` array.
/// Each middleware can modify the request, and subsequent middleware will see the
/// modified request.
///
/// ## Common Use Cases
///
/// - **Authentication**: Add authorization headers
/// - **Logging**: Log request details before sending
/// - **Request Transformation**: Modify request body or headers
/// - **Validation**: Validate request parameters
/// - **Rate Limiting**: Add rate limiting headers
/// - **Caching**: Add cache control headers
///
/// ## Thread Safety
///
/// Middleware must be thread-safe since they can be called from concurrent contexts.
/// The protocol conforms to `Sendable` to enforce this requirement.
public protocol Middleware: Sendable {
    /// Modifies the given URLRequest before it is sent.
    ///
    /// This method is called for each request, allowing the middleware to inspect
    /// and modify the request as needed. Common modifications include:
    /// - Adding or modifying headers
    /// - Transforming the request body
    /// - Adding query parameters
    /// - Modifying the URL
    ///
    /// - Parameter request: The URLRequest to modify (inout parameter)
    /// - Throws: An error if the middleware cannot process the request
    func modify(request: inout URLRequest) async throws
}
