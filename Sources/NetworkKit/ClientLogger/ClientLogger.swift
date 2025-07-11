//
//  ClientLogger.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

/// A protocol that defines logging functionality for HTTP requests and responses.
///
/// `ClientLogger` provides a way to log detailed information about HTTP requests
/// and responses for debugging, monitoring, and auditing purposes. You can implement
/// custom loggers to integrate with your preferred logging system.
///
/// ## Usage
///
/// ```swift
/// struct CustomLogger: ClientLogger {
///     func logPerform(request: URLRequest) {
///         print("🚀 Sending request: \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "")")
///     }
///
///     func logResponse(request: URLRequest, response: URLResponse, data: Data) {
///         if let httpResponse = response as? HTTPURLResponse {
///             print("📥 Received response: \(httpResponse.statusCode)")
///         }
///     }
/// }
///
/// // Use custom logger
/// var client = Client("https://api.example.com")
/// client.logger = CustomLogger()
/// ```
///
/// ## Default Logger
///
/// NetworkKit provides a default logger (`DefaultClientLogger`) that uses the system
/// logger (OSLog) to provide comprehensive logging with proper formatting and
/// categorization. You can disable logging by setting the logger to `nil`.
///
/// ## Logging Information
///
/// The logger receives detailed information about:
/// - **Requests**: HTTP method, URL, headers, and body
/// - **Responses**: Status code, headers, and response body
/// - **Timing**: When requests are sent and responses are received
///
/// ## Thread Safety
///
/// Loggers must be thread-safe since they can be called from concurrent contexts.
/// The protocol conforms to `Sendable` to enforce this requirement.
public protocol ClientLogger: Sendable {
    /// Logs information about an outgoing HTTP request.
    ///
    /// This method is called just before a request is sent, providing an opportunity
    /// to log request details for debugging or monitoring purposes.
    ///
    /// - Parameter request: The URLRequest that is about to be sent
    func logPerform(request: URLRequest)

    /// Logs information about a received HTTP response.
    ///
    /// This method is called after a response is received, providing an opportunity
    /// to log response details for debugging or monitoring purposes.
    ///
    /// - Parameters:
    ///   - request: The original URLRequest that was sent
    ///   - response: The URLResponse that was received
    ///   - data: The raw response data that was received
    func logResponse(request: URLRequest, response: URLResponse, data: Data)
}
