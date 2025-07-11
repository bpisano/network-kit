//
//  Query.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

/// A protocol that defines how query parameter values are converted to strings.
///
/// Types conforming to `QueryProtocol` can be used as query parameters in HTTP requests.
/// The protocol provides a way to convert any type to a string representation suitable
/// for URL query parameters.
///
/// ## Usage
///
/// ```swift
/// struct SearchRequest: HttpRequest {
///     let path = "/search"
///     let method: HttpMethod = .get
///
///     @Query
///     var query: String
///
///     @Query
///     var page: Int
///
///     @Query
///     var limit: Int
/// }
/// ```
public protocol QueryProtocol {
    /// The string representation of the query parameter value.
    ///
    /// This value will be used as the query parameter value in the URL.
    /// For example, if this returns "hello", the query parameter will be "?name=hello".
    var queryValue: String { get }
}

/// A property wrapper that marks a property as a query parameter in an HTTP request.
///
/// Use `@Query` to indicate that a property should be added as a query parameter
/// to the request URL. Query parameters are automatically appended to the URL
/// in the format `?name=value&name2=value2`.
///
/// ## Usage
///
/// ```swift
/// struct GetUsersRequest: HttpRequest {
///     let path = "/users"
///     let method: HttpMethod = .get
///
///     @Query
///     var page: Int
///
///     @Query
///     var limit: Int
///
///     @Query
///     var search: String
/// }
///
/// // Usage
/// let request = GetUsersRequest()
/// request.page = 1
/// request.limit = 20
/// request.search = "john"
/// // Results in URL: "/users?page=1&limit=20&search=john"
/// ```
///
/// ## Supported Types
///
/// Any type that conforms to `CustomStringConvertible` can be used with `@Query`:
/// - `String`
/// - `Int`
/// - `Double`
/// - `Bool`
/// - `Date` (if it conforms to `CustomStringConvertible`)
/// - Custom types that conform to `CustomStringConvertible`
///
/// ## Query Parameter Format
///
/// Query parameters are automatically URL-encoded and appended to the request URL:
/// - Multiple parameters are separated by `&`
/// - Special characters are automatically encoded
/// - The property name becomes the query parameter name
/// - The property value becomes the query parameter value
@propertyWrapper
public struct Query<T: CustomStringConvertible>: QueryProtocol {
    /// The wrapped value that will be converted to a query parameter.
    public var wrappedValue: T

    /// Creates a query parameter wrapper with the specified value.
    ///
    /// - Parameter wrappedValue: The value that will be converted to a query parameter
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    /// The string representation of the query parameter value.
    ///
    /// This uses the `description` property of the wrapped value to convert it
    /// to a string suitable for use as a query parameter.
    public var queryValue: String {
        wrappedValue.description
    }
}

/// Makes Query conform to Sendable when its wrapped value type is Sendable.
///
/// This allows Query objects to be safely passed across concurrency boundaries
/// when the wrapped value type is thread-safe.
extension Query: Sendable where T: Sendable {}
