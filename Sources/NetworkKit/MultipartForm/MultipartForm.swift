//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 19/08/2023.
//

import Foundation

/// A struct representing a multipart form data for use as an HTTP body in network requests.
public struct MultipartForm: HttpBody {
    private var data: Data
    private let boundary: String = "test"

    public var debugDescription: String {
        String(data: data, encoding: .utf8) ?? "Unable to represent form data as String."
    }

    /// A dictionary of headers to override the default headers for the multipart form data.
    public var overrideHeaders: HttpHeaders? {
        HttpHeader("Content-Type", value: "multipart/form-data; boundary=\(boundary)")
    }

    /// Initializes a multipart form data using a builder closure to define the form fields.
    /// - Parameter fields: A closure that returns an array of `MultipartFormField` instances.
    public init(@MultipartFormBuilder _ fields: () -> [any MultipartFormField]) {
        data = .init()
        data = fields().reduce(into: Data(), { data, field in
            data.append(field.data(with: boundary))
        })
    }

    /// Initializes a multipart form data with the provided data.
    /// - Parameter data: The data to be used for the multipart form.
    public init(data: Data) {
        self.data = data
    }

    /// Encodes the multipart form data using the given JSON encoder.
    /// - Parameter jsonEncoder: The JSON encoder to use for encoding.
    /// - Returns: The encoded data of the multipart form.
    public func encode(using jsonEncoder: JSONEncoder) throws -> Data {
        var fieldsData: Data = data
        fieldsData.append(text: "--\(boundary)--\r\n")
        return fieldsData
    }
}
