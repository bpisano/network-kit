//
//  Interceptor.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

/// A protocol that defines interceptors for modifying HTTP responses after they are received.
///
/// Interceptors provide a way to intercept and modify responses at various stages of
/// the response lifecycle. Common use cases include response transformation, error handling,
/// logging, caching, and retry logic.
///
/// ## Usage
///
/// ```swift
/// struct RetryInterceptor: Interceptor {
///     let maxRetries: Int
///     let retryDelay: TimeInterval
///
///     func intercept(
///         data: Data,
///         response: URLResponse,
///         client: HttpClient,
///         request: some HttpRequest
///     ) async throws -> (data: Data, response: URLResponse) {
///         if let httpResponse = response as? HTTPURLResponse,
///            httpResponse.statusCode >= 500 {
///             // Implement retry logic here
///         }
///         return (data, response)
///     }
/// }
///
/// // Add interceptor to a client
/// var client = Client("https://api.example.com")
/// client.interceptors = [RetryInterceptor(maxRetries: 3, retryDelay: 1.0)]
/// ```
///
/// ## Interceptor Execution Order
///
/// Interceptors are executed in the order they appear in the client's `interceptors` array.
/// Each interceptor can modify both the response data and the response object, and
/// subsequent interceptors will see the modified response.
///
/// ## Common Use Cases
///
/// - **Error Handling**: Transform error responses into custom error types
/// - **Response Transformation**: Modify response data before decoding
/// - **Logging**: Log response details after receiving
/// - **Caching**: Cache successful responses
/// - **Retry Logic**: Automatically retry failed requests
/// - **Response Validation**: Validate response format or content
/// - **Data Processing**: Pre-process response data (e.g., decompression)
///
/// ## Thread Safety
///
/// Interceptors must be thread-safe since they can be called from concurrent contexts.
/// The protocol conforms to `Sendable` to enforce this requirement.
public protocol Interceptor: Sendable {
    /// Intercepts and optionally modifies the response data and response object.
    ///
    /// This method is called after a response is received but before it is processed
    /// by the client. The interceptor can inspect and modify both the response data
    /// and the response object as needed.
    ///
    /// - Parameters:
    ///   - data: The raw response data received from the server
    ///   - response: The URLResponse object containing response metadata
    ///   - client: The HttpClient that made the request
    ///   - request: The original HttpRequest that was sent
    /// - Returns: A tuple containing the potentially modified data and response
    /// - Throws: An error if the interceptor cannot process the response
    func intercept(
        data: Data,
        response: URLResponse,
        client: HttpClient,
        request: some HttpRequest
    ) async throws -> (data: Data, response: URLResponse)
}
