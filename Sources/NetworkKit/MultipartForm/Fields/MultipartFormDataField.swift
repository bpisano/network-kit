//
//  MultipartFormDataField.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

/// A multipart form field for binary data (file uploads).
///
/// `DataField` represents a file field in a multipart/form-data request. It's used
/// for uploading files, images, or any binary data with proper MIME type handling.
///
/// ## Usage
///
/// ```swift
/// let form = MultipartForm {
///     DataField(
///         "avatar",
///         data: imageData,
///         mimeType: .jpegImage,
///         fileName: "avatar.jpg"
///     )
///     DataField(
///         "document",
///         data: pdfData,
///         mimeType: .pdfDocument,
///         fileName: "report.pdf"
///     )
/// }
/// ```
///
/// ## Field Format
///
/// The field is formatted as:
/// ```
/// --{boundary}
/// Content-Disposition: form-data; name="fieldName"; filename="fileName"
/// Content-Type: {mimeType}
///
/// {binaryData}
/// ```
///
/// ## Content Headers
///
/// Data fields automatically include:
/// - `Content-Type`: Set to the specified MIME type
/// - `Content-Disposition`: Includes field name and optional filename
///
/// ## File Name
///
/// The `fileName` parameter is optional. When provided, it's included in the
/// Content-Disposition header to help the server identify the uploaded file.
/// If not provided, the filename will be empty in the header.
public struct DataField: MultipartFormField {
    /// The name of the form field.
    private let name: String

    /// The binary data to upload.
    private let data: Data

    /// The MIME type of the data.
    private let mimeType: MimeType

    /// The optional filename for the uploaded data.
    private let fileName: String?

    /// Creates a data field with the specified parameters.
    ///
    /// - Parameters:
    ///   - name: The name of the form field (used in Content-Disposition header)
    ///   - data: The binary data to upload
    ///   - mimeType: The MIME type of the data (e.g., .jpegImage, .pdfDocument)
    ///   - fileName: The optional filename for the uploaded data
    public init(
        _ name: String,
        data: Data,
        mimeType: MimeType,
        fileName: String? = nil
    ) {
        self.name = name
        self.data = data
        self.mimeType = mimeType
        self.fileName = fileName
    }

    /// Converts the data field to multipart form data.
    ///
    /// This method formats the data field according to the multipart/form-data
    /// specification, including proper headers, boundaries, and binary data.
    ///
    /// - Parameter boundary: The boundary string used to separate form fields
    /// - Returns: The formatted multipart data for this data field
    public func data(with boundary: String) -> Data {
        var fieldData: Data = Data()
        fieldData.append(text: "--\(boundary)\r\n")
        fieldData.append(
            text:
                "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName ?? "")\"\r\n"
        )
        fieldData.append(text: "Content-Type: \(mimeType)\r\n")
        fieldData.append(text: "\r\n")
        fieldData.append(data)
        fieldData.append(text: "\r\n")
        return fieldData
    }
}
