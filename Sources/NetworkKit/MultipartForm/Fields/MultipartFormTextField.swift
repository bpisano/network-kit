//
//  MultipartFormTextField.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

/// A multipart form field for text data.
///
/// `MultipartFormTextField` represents a simple text field in a multipart/form-data
/// request. It's used for sending string values as form fields.
///
/// ## Usage
///
/// ```swift
/// let form = MultipartForm {
///     TextField(named: "username", value: "john_doe")
///     TextField(named: "email", value: "john@example.com")
///     TextField(named: "description", value: "User profile")
/// }
/// ```
///
/// ## Field Format
///
/// The field is formatted as:
/// ```
/// --{boundary}
/// Content-Disposition: form-data; name="fieldName"
/// Content-Type: text/plain; charset=ISO-8859-1
/// Content-Transfer-Encoding: 8bit
///
/// fieldValue
/// ```
///
/// ## Content Headers
///
/// Text fields automatically include:
/// - `Content-Type: text/plain; charset=ISO-8859-1`
/// - `Content-Transfer-Encoding: 8bit`
/// - `Content-Disposition: form-data; name="fieldName"`
public struct MultipartFormTextField: MultipartFormField {
    /// The name of the form field.
    private let name: String

    /// The string value of the form field.
    private let value: String

    /// Creates a text field with the specified name and value.
    ///
    /// - Parameters:
    ///   - name: The name of the form field (used in Content-Disposition header)
    ///   - value: The string value to send as the field content
    public init(
        named name: String,
        value: String
    ) {
        self.name = name
        self.value = value
    }

    /// Converts the text field to multipart form data.
    ///
    /// This method formats the text field according to the multipart/form-data
    /// specification, including proper headers and boundaries.
    ///
    /// - Parameter boundary: The boundary string used to separate form fields
    /// - Returns: The formatted multipart data for this text field
    public func data(with boundary: String) -> Data {
        var fieldString: Data = Data()
        fieldString.append(text: "--\(boundary)\r\n")
        fieldString.append(
            text: "Content-Disposition: form-data; name=\"\(name)\"; filename=\"image\"\r\n")
        fieldString.append(text: "Content-Type: text/plain; charset=ISO-8859-1\r\n")
        fieldString.append(text: "Content-Transfer-Encoding: 8bit\r\n")
        fieldString.append(text: "\r\n")
        fieldString.append(text: "\(value)\r\n")
        return fieldString
    }
}
