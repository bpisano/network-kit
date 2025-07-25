//
//  HttpBody.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

/// A protocol that defines how to modify an HTTP request with body data.
///
/// Types conforming to `HttpBody` can be used to set the body of an HTTP request.
/// This protocol provides a flexible way to handle different types of request bodies,
/// including JSON data, form data, and custom body formats.
///
/// ## Usage
///
/// ```swift
/// struct User: Codable {
///     let name: String
///     let email: String
/// }
///
/// struct CreateUserRequest: HttpRequest {
///     let path = "/users"
///     let method: HttpMethod = .post
///     let body: User  // User conforms to Codable, so it automatically conforms to HttpBody
/// }
/// ```
///
/// ## Default Implementation
///
/// Types that conform to both `HttpBody` and `Encodable` automatically get a default
/// implementation that encodes the data as JSON and sets the appropriate headers.
///
/// - Parameter request: The URLRequest to modify
/// - Parameter encoder: The JSONEncoder to use for encoding (if applicable)
/// - Throws: An error if the body cannot be properly encoded or set
public protocol HttpBody: Encodable {
    /// Modifies the given URLRequest with the body data.
    ///
    /// This method is responsible for setting the `httpBody` property and any
    /// relevant headers (like `Content-Type` and `Content-Length`).
    ///
    /// - Parameters:
    ///   - request: The URLRequest to modify
    ///   - encoder: The JSONEncoder to use for encoding (if applicable)
    /// - Throws: An error if the body cannot be properly encoded or set
    func modify(_ request: inout URLRequest, using encoder: JSONEncoder) throws
}

extension HttpBody where Self: Encodable {
    /// Default implementation for Encodable types that encodes the data as JSON.
    ///
    /// This implementation:
    /// 1. Encodes the conforming type to JSON data
    /// 2. Sets the `httpBody` property of the request
    /// 3. Sets the `Content-Type` header to `application/json`
    /// 4. Sets the `Content-Length` header to the size of the encoded data
    ///
    /// - Parameters:
    ///   - request: The URLRequest to modify
    ///   - encoder: The JSONEncoder to use for encoding
    /// - Throws: An error if the encoding fails
    public func modify(_ request: inout URLRequest, using encoder: JSONEncoder) throws {
        let encodedBody: Data = try encoder.encode(self)
        request.httpBody = encodedBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(encodedBody.count)", forHTTPHeaderField: "Content-Length")
    }
}

/// A type representing an empty HTTP request body.
///
/// Use this type when your HTTP request doesn't need a body (e.g., GET requests).
/// The `HttpRequest` protocol provides a default implementation that returns
/// an `EmptyBody` instance when no body is specified.
///
/// ## Usage
///
/// ```swift
/// struct GetUserRequest: HttpRequest {
///     let path = "/users/:id"
///     let method: HttpMethod = .get
///     // No body property needed - defaults to EmptyBody
/// }
/// ```
public struct EmptyBody: HttpBody {
    public init() {}

    public func modify(_ request: inout URLRequest, using encoder: JSONEncoder) throws {}
}

// MARK: - HttpBody Conformance

extension Data: HttpBody {
    public func modify(_ request: inout URLRequest, using encoder: JSONEncoder) throws {
        request.httpBody = self
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.count)", forHTTPHeaderField: "Content-Length")
    }
}

extension String: HttpBody {
    public func modify(_ request: inout URLRequest, using encoder: JSONEncoder) throws {
        guard let data = self.data(using: .utf8) else {
            throw NSError(
                domain: "HttpBodyError",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Failed to convert String to Data"]
            )
        }
        request.httpBody = data
        request.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
    }
}

extension Int: HttpBody {
    public func modify(_ request: inout URLRequest, using encoder: JSONEncoder) throws {
        let data = String(self).data(using: .utf8)!
        request.httpBody = data
        request.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
    }
}

extension Double: HttpBody {
    public func modify(_ request: inout URLRequest, using encoder: JSONEncoder) throws {
        let data = String(self).data(using: .utf8)!
        request.httpBody = data
        request.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
    }
}

extension Float: HttpBody {
    public func modify(_ request: inout URLRequest, using encoder: JSONEncoder) throws {
        let data = String(self).data(using: .utf8)!
        request.httpBody = data
        request.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
    }
}

extension Bool: HttpBody {
    public func modify(_ request: inout URLRequest, using encoder: JSONEncoder) throws {
        let data = String(self).data(using: .utf8)!
        request.httpBody = data
        request.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
    }
}

extension Dictionary: HttpBody where Key == String, Value == String {}

extension Array: HttpBody where Element: Encodable {}

extension Set: HttpBody where Element: Encodable {}

extension Optional: HttpBody where Wrapped: Encodable {
    public func modify(_ request: inout URLRequest, using encoder: JSONEncoder) throws {
        switch self {
        case .some(let wrapped):
            let encodedBody: Data = try encoder.encode(wrapped)
            request.httpBody = encodedBody
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("\(encodedBody.count)", forHTTPHeaderField: "Content-Length")
        case .none:
            request.httpBody = nil
            request.setValue(nil, forHTTPHeaderField: "Content-Type")
            request.setValue(nil, forHTTPHeaderField: "Content-Length")
        }
    }
}
