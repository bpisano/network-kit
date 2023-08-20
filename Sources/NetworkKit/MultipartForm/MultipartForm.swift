//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 19/08/2023.
//

import Foundation

public struct MultipartForm: HttpBody {
    private var data: Data
    private let boundary: String = "test"

    public var overrideHeaders: HttpHeaders? {
        HttpHeader("Content-Type", value: "multipart/form-data; boundary=\(boundary)")
    }

    public init(@MultipartFormBuilder _ fields: () -> [any MultipartFormField]) {
        data = .init()
        data = fields().reduce(into: Data(), { data, field in
            data.append(field.data(with: boundary))
        })
    }

    public init(data: Data) {
        self.data = data
    }

    public func encode(using jsonEncoder: JSONEncoder) throws -> Data {
        var fieldsData: Data = data
        fieldsData.append(text: "--\(boundary)--\r\n")
        return fieldsData
    }
}
