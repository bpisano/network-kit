//
//  MultipartForm.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

/// A type representing multipart/form-data for HTTP requests.
///
/// `MultipartForm` allows you to send form data with files and text fields in a single
/// HTTP request. It automatically handles the multipart boundary and proper formatting
/// of the request body.
///
/// ## Usage
///
/// ```swift
/// struct UploadRequest: HttpRequest {
///     let path = "/upload"
///     let method: HttpMethod = .post
///     let body: MultipartForm
///
///     init(fileData: Data, fileName: String, description: String) {
///         self.body = MultipartForm {
///             DataField(
///                 named: "file",
///                 data: fileData,
///                 mimeType: .jpegImage,
///                 fileName: fileName
///             )
///             TextField(named: "description", value: description)
///         }
///     }
/// }
/// ```
///
/// ## Supported Field Types
///
/// - `DataField`: For file uploads with binary data
/// - `TextField`: For text form fields
///
/// ## Multipart Boundary
///
/// The form uses a fixed boundary string "networkkit" to separate form fields.
/// This boundary is automatically included in the Content-Type header.
///
/// ## Content-Type Header
///
/// When used as a request body, `MultipartForm` automatically sets the
/// `Content-Type` header to `multipart/form-data; boundary=networkkit`.
public struct MultipartForm: HttpBody {
    /// The raw multipart form data.
    private var data: Data

    /// The boundary string used to separate form fields.
    ///
    /// This is a fixed boundary that ensures proper parsing of the multipart data.
    private let boundary: String = "networkkit"

    /// Creates a multipart form with the specified fields.
    ///
    /// This initializer uses a result builder to create a clean, declarative syntax
    /// for defining form fields. The fields are processed in the order they appear.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let form = MultipartForm {
    ///     TextField(named: "name", value: "John Doe")
    ///     DataField(
    ///         named: "avatar",
    ///         data: imageData,
    ///         mimeType: .jpegImage,
    ///         fileName: "avatar.jpg"
    ///     )
    /// }
    /// ```
    ///
    /// - Parameter fields: A closure that returns an array of multipart form fields
    public init(@MultipartFormBuilder _ fields: () -> [any MultipartFormField]) {
        data = .init()
        data = fields().reduce(
            into: Data(),
            { data, field in
                data.append(field.data(with: boundary))
            })
    }

    /// Creates a multipart form with pre-existing data.
    ///
    /// This initializer is useful when you have already formatted multipart data
    /// and want to use it directly.
    ///
    /// - Parameter data: The pre-formatted multipart form data
    public init(data: Data) {
        self.data = data
    }

    /// Modifies the URLRequest to include the multipart form data.
    ///
    /// This method sets the request body to the multipart data and configures
    /// the appropriate Content-Type header with the boundary.
    ///
    /// - Parameters:
    ///   - urlRequest: The URLRequest to modify
    ///   - jsonEncoder: The JSONEncoder (unused for multipart forms)
    public func modify(_ urlRequest: inout URLRequest, using jsonEncoder: JSONEncoder) throws {
        urlRequest.httpBody = data
        urlRequest.setValue(
            "multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    }
}
