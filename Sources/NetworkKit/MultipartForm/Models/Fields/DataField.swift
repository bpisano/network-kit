//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 19/08/2023.
//

import Foundation

/// A struct representing a data field within a multipart form for file uploads.
public struct DataField: MultipartFormField {
    private let name: String
    private let data: Data
    private let mimeType: MimeType
    private let fileName: String?

    /// Initializes a data field for the multipart form.
    /// - Parameters:
    ///   - name: The name of the field.
    ///   - data: The data to be included in the field.
    ///   - mimeType: The MIME type of the data.
    ///   - fileName: The name of the file associated with the data. Defaults to `nil`.
    public init(
        named name: String,
        data: Data,
        mimeType: MimeType,
        fileName: String? = nil
    ) {
        self.name = name
        self.data = data
        self.mimeType = mimeType
        self.fileName = fileName
    }

    /// Creates the data representation of the data field with the specified boundary.
    /// - Parameter boundary: The boundary used for separating fields in the multipart form.
    /// - Returns: The data representation of the data field.
    public func data(with boundary: String) -> Data {
        var fieldData: Data = Data()
        fieldData.append(text: "--\(boundary)\r\n")
        fieldData.append(text: "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName ?? "")\"\r\n")
        fieldData.append(text: "Content-Type: \(mimeType)\r\n")
        fieldData.append(text: "\r\n")
        fieldData.append(data)
        fieldData.append(text: "\r\n")
        return fieldData
    }
}
