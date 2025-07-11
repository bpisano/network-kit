//
//  DataExtension.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

extension Data {
    /// Appends a string to the data object as UTF-8 encoded bytes.
    ///
    /// This method is used internally by NetworkKit for building multipart form data.
    /// It converts the string to UTF-8 data and appends it to the existing data object.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// var data = Data()
    /// data.append(text: "--boundary\r\n")
    /// data.append(text: "Content-Disposition: form-data; name=\"field\"\r\n")
    /// data.append(text: "\r\n")
    /// data.append(text: "field value\r\n")
    /// ```
    ///
    /// ## Encoding Behavior
    ///
    /// - Uses UTF-8 encoding with lossy conversion allowed
    /// - If the string cannot be encoded, the method silently returns without appending
    /// - This ensures that even strings with invalid UTF-8 sequences don't crash the app
    ///
    /// ## Common Use Cases
    ///
    /// This method is primarily used for:
    /// - Building multipart form data boundaries
    /// - Adding HTTP headers to multipart data
    /// - Appending text content to binary data
    ///
    /// - Parameter text: The string to append as UTF-8 data
    mutating func append(text: String) {
        guard let data = text.data(using: .utf8, allowLossyConversion: true) else { return }
        append(data)
    }
}
