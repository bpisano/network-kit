//
//  MultipartFormResultBuilder.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

/// A result builder that enables declarative syntax for creating multipart form fields.
///
/// `MultipartFormBuilder` allows you to use a clean, declarative syntax when creating
/// `MultipartForm` instances. It automatically collects all the form fields and
/// returns them as an array.
///
/// ## Usage
///
/// ```swift
/// let form = MultipartForm {
///     TextField(named: "username", value: "john_doe")
///     TextField(named: "email", value: "john@example.com")
///     DataField(
///         named: "avatar",
///         data: imageData,
///         mimeType: .jpegImage,
///         fileName: "avatar.jpg"
///     )
/// }
/// ```
///
/// ## Supported Field Types
///
/// The result builder accepts any type that conforms to `MultipartFormField`:
/// - `TextField`: For text form fields
/// - `DataField`: For file uploads
/// - Custom field types that conform to `MultipartFormField`
///
/// ## Field Order
///
/// Fields are processed in the order they appear in the closure. This order is
/// preserved in the final multipart form data.
///
/// ## Syntax Benefits
///
/// The result builder provides several benefits:
/// - **Readability**: Clear, declarative syntax
/// - **Type Safety**: Compile-time checking of field types
/// - **Flexibility**: Easy to add or remove fields
/// - **Maintainability**: Self-documenting code structure
@resultBuilder
public struct MultipartFormBuilder {
    /// Builds an array of multipart form fields from the provided components.
    ///
    /// This method is automatically called by the result builder to collect all
    /// the form fields specified in the closure.
    ///
    /// - Parameter components: Variable number of multipart form fields
    /// - Returns: An array containing all the form fields
    public static func buildBlock(_ components: MultipartFormField...) -> [any MultipartFormField] {
        components
    }
}
