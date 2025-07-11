//
//  DefaultClientLogger.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation
import OSLog

/// A default implementation of `ClientLogger` that provides comprehensive logging using the system logger.
///
/// `DefaultClientLogger` uses Apple's unified logging system (OSLog) to provide structured,
/// categorized logging that integrates well with Console.app and other system logging tools.
/// It automatically formats request and response information for easy debugging.
///
/// ## Usage
///
/// ```swift
/// // Use the default logger (automatically configured)
/// let client = Client("https://api.example.com")
/// // client.logger is automatically set to DefaultClientLogger.default
///
/// // Or explicitly set it
/// var client = Client("https://api.example.com")
/// client.logger = DefaultClientLogger()
/// ```
///
/// ## Logging Features
///
/// - **Request Logging**: HTTP method, URL, headers, and body (if present)
/// - **Response Logging**: Status code, headers, and response body
/// - **Visual Indicators**: Emojis to quickly identify request (🚀) and response (✅/❌) logs
/// - **Structured Format**: Well-formatted output with clear sections
/// - **System Integration**: Logs appear in Console.app and Xcode console
///
/// ## Log Categories
///
/// Logs are categorized under the subsystem "bpisano.networkkit" and category "ClientLogger",
/// making them easy to filter and search in Console.app.
public struct DefaultClientLogger: ClientLogger {
    /// The system logger instance used for logging.
    ///
    /// Uses the subsystem "bpisano.networkkit" and category "ClientLogger" for
    /// proper organization in Console.app.
    private let logger: Logger = .init(subsystem: "bpisano.networkkit", category: "ClientLogger")

    /// Creates a new default client logger instance.
    ///
    /// This initializer creates a logger with the default configuration.
    public init() {}

    /// Logs detailed information about an outgoing HTTP request.
    ///
    /// This method formats and logs:
    /// - HTTP method and URL
    /// - Request headers (if any)
    /// - Request body (if present and not empty)
    ///
    /// The log is prefixed with 🚀 to indicate an outgoing request.
    ///
    /// - Parameter request: The URLRequest that is about to be sent
    public func logPerform(request: URLRequest) {
        let headersDescription = formatHeaders(request.allHTTPHeaderFields)

        if let body = request.httpBody?.prettyJson, !body.isEmpty {
            logger.debug(
                "🚀 \(requestDescription(request: request))\n\(headersDescription)\n- Body \(body)")
        } else {
            logger.debug("🚀 \(requestDescription(request: request))\n\(headersDescription)")
        }
    }

    /// Logs detailed information about a received HTTP response.
    ///
    /// This method formats and logs:
    /// - HTTP method and URL
    /// - Response status code
    /// - Response headers (if any)
    /// - Response body
    ///
    /// The log is prefixed with ✅ for successful responses (2xx status codes)
    /// or ❌ for error responses (4xx/5xx status codes).
    ///
    /// - Parameters:
    ///   - request: The original URLRequest that was sent
    ///   - response: The URLResponse that was received
    ///   - data: The raw response data that was received
    public func logResponse(request: URLRequest, response: URLResponse, data: Data) {
        let headersDescription: String
        if let httpResponse = response as? HTTPURLResponse {
            headersDescription = formatHeaders(httpResponse.allHeaderFields)
        } else {
            headersDescription = "Headers: None"
        }

        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                logger.debug(
                    "✅ \(requestDescription(request: request)) - \(httpResponse.statusCode)\n\(headersDescription)\n- Body \(data.prettyJson)"
                )
            } else {
                logger.debug(
                    "❌ \(requestDescription(request: request)) - \(httpResponse.statusCode)\n\(headersDescription)\n\(data.prettyJson)"
                )
            }
        } else {
            logger.debug(
                "✅ \(requestDescription(request: request))\n\(headersDescription)\n- Body \(data.prettyJson)"
            )
        }
    }

    /// Creates a formatted description of the request for logging.
    ///
    /// Returns a string in the format "METHOD URL" (e.g., "GET https://api.example.com/users").
    ///
    /// - Parameter request: The URLRequest to describe
    /// - Returns: A formatted string describing the request
    private func requestDescription(request: URLRequest) -> String {
        let method = request.httpMethod ?? "GET"
        let url = request.url?.absoluteString ?? "Unknown URL"
        return "\(method) \(url)"
    }

    /// Formats HTTP headers for logging output.
    ///
    /// Converts the headers dictionary into a readable format with proper indentation.
    /// Returns "Headers: None" if no headers are present.
    ///
    /// - Parameter headers: The headers dictionary to format
    /// - Returns: A formatted string representation of the headers
    private func formatHeaders(_ headers: [AnyHashable: Any]?) -> String {
        guard let headers = headers, !headers.isEmpty else {
            return "- Headers: None"
        }
        return "- Headers:\n" + headers.map { "    \($0.key): \($0.value)" }.joined(separator: "\n")
    }
}

extension ClientLogger where Self == DefaultClientLogger {
    /// Provides a convenient way to access the default client logger.
    ///
    /// This static property returns a new instance of `DefaultClientLogger` and is
    /// used as the default logger for all clients unless explicitly overridden.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// var client = Client("https://api.example.com")
    /// client.logger = .default  // Same as DefaultClientLogger()
    /// ```
    public static var `default`: Self {
        .init()
    }
}

extension Data {
    /// Converts the data to a pretty-printed JSON string for logging.
    ///
    /// This extension provides a convenient way to format JSON data for logging output.
    /// If the data is not valid JSON, it falls back to a UTF-8 string representation.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let jsonData = try JSONSerialization.data(withJSONObject: ["key": "value"])
    /// print(jsonData.prettyJson)  // Pretty-printed JSON
    /// ```
    ///
    /// - Returns: A formatted JSON string, or a UTF-8 string if not valid JSON
    fileprivate var prettyJson: String {
        guard let json = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]),
            let prettyJsonString = String(data: data, encoding: .utf8)
        else {
            return String(data: self, encoding: .utf8) ?? "Invalid JSON"
        }
        return prettyJsonString
    }
}
