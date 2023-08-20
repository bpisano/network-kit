//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 19/08/2023.
//

import Foundation

public struct DataField: MultipartFormField {
    private let name: String
    private let data: Data
    private let mimeType: MimeType
    private let fileName: String?

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
