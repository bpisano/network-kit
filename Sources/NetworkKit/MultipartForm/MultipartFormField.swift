//
//  MultipartFormField.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

/// A protocol that defines the interface for multipart form fields.
///
/// `MultipartFormField` provides a way to represent different types of form fields
/// in multipart/form-data requests. Each field type (text, file, etc.) implements
/// this protocol to provide its specific data formatting.
///
/// ## Usage
///
/// ```swift
/// struct CustomField: MultipartFormField {
///     let name: String
///     let value: String
///
///     func data(with boundary: String) -> Data {
///         var fieldData = Data()
///         fieldData.append(text: "--\(boundary)\r\n")
///         fieldData.append(text: "Content-Disposition: form-data; name=\"\(name)\"\r\n")
///         fieldData.append(text: "\r\n")
///         fieldData.append(text: "\(value)\r\n")
///         return fieldData
///     }
/// }
/// ```
///
/// ## Field Types
///
/// NetworkKit provides two built-in field types:
/// - `TextField`: For simple text form fields
/// - `DataField`: For file uploads with binary data
///
/// ## Data Format
///
/// Each field must format its data according to the multipart/form-data specification:
/// 1. Boundary line: `--{boundary}\r\n`
/// 2. Headers (Content-Disposition, Content-Type, etc.)
/// 3. Empty line: `\r\n`
/// 4. Field data
/// 5. Line ending: `\r\n`
///
/// ## Boundary Parameter
///
/// The `boundary` parameter is provided by the `MultipartForm` and should be used
/// to properly separate fields in the multipart data.
public protocol MultipartFormField {
    /// Converts the field to multipart form data using the specified boundary.
    ///
    /// This method is responsible for formatting the field according to the
    /// multipart/form-data specification, including proper headers and boundaries.
    ///
    /// - Parameter boundary: The boundary string used to separate form fields
    /// - Returns: The formatted multipart data for this field
    func data(with boundary: String) -> Data
}
