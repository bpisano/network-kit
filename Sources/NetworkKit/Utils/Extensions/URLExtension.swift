//
//  URLExtension.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

extension URL {
    /// Replaces a path parameter in the URL with a new value.
    ///
    /// This method is used internally by NetworkKit to replace path parameters
    /// (denoted by `:parameterName`) with actual values when building request URLs.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let url = URL(string: "https://api.example.com/users/:id/posts/:postId")!
    /// let newUrl = url.replacingPathParameter("id", with: "123")
    /// // Result: "https://api.example.com/users/123/posts/:postId"
    ///
    /// let finalUrl = newUrl?.replacingPathParameter("postId", with: "456")
    /// // Result: "https://api.example.com/users/123/posts/456"
    /// ```
    ///
    /// ## Path Parameter Format
    ///
    /// Path parameters must be prefixed with a colon (`:`) in the URL path:
    /// - `:id` - will be replaced with the provided value
    /// - `:userId` - will be replaced with the provided value
    /// - `:postId` - will be replaced with the provided value
    ///
    /// ## Return Value
    ///
    /// Returns a new URL with the path parameter replaced, or `nil` if the URL
    /// cannot be constructed (e.g., invalid URL components).
    ///
    /// - Parameters:
    ///   - parameter: The path parameter name (without the colon)
    ///   - value: The value to replace the parameter with
    /// - Returns: A new URL with the parameter replaced, or `nil` if construction fails
    func replacingPathParameter(_ parameter: String, with value: String) -> URL? {
        let pattern: String = ":\(parameter)"
        let newPath: String = self.path
            .components(separatedBy: "/")
            .map { $0 == pattern ? value : $0 }
            .joined(separator: "/")

        var components: URLComponents = .init(url: self, resolvingAgainstBaseURL: false) ?? .init()
        components.path = newPath
        return components.url
    }

    /// Appends a query parameter to the URL.
    ///
    /// This method is used internally by NetworkKit to add query parameters
    /// to request URLs. It properly handles existing query parameters and
    /// URL encoding.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let url = URL(string: "https://api.example.com/users")!
    /// let newUrl = url.appendingQueryParameter("page", with: "1")
    /// // Result: "https://api.example.com/users?page=1"
    ///
    /// let finalUrl = newUrl?.appendingQueryParameter("limit", with: "20")
    /// // Result: "https://api.example.com/users?page=1&limit=20"
    /// ```
    ///
    /// ## Query Parameter Handling
    ///
    /// - If the URL already has query parameters, new ones are appended
    /// - Parameters are automatically URL-encoded
    /// - Multiple parameters are separated by `&`
    /// - The method preserves existing query parameters
    ///
    /// ## Return Value
    ///
    /// Returns a new URL with the query parameter added, or `nil` if the URL
    /// cannot be constructed (e.g., invalid URL components).
    ///
    /// - Parameters:
    ///   - name: The query parameter name
    ///   - value: The query parameter value
    /// - Returns: A new URL with the parameter added, or `nil` if construction fails
    func appendingQueryParameter(_ name: String, with value: String) -> URL? {
        var components: URLComponents = .init(url: self, resolvingAgainstBaseURL: false) ?? .init()
        var existingQueryItems = components.queryItems ?? []
        existingQueryItems.append(URLQueryItem(name: name, value: value))
        components.queryItems = existingQueryItems
        return components.url
    }
}
