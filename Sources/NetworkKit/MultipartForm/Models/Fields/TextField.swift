//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 19/08/2023.
//

import Foundation

public struct TextField: MultipartFormField {
    private let name: String
    private let value: String

    public init(
        named name: String,
        value: String
    ) {
        self.name = name
        self.value = value
    }

    public func data(with boundary: String) -> Data {
        var fieldString: Data = Data()
        fieldString.append(text: "--\(boundary)\r\n")
        fieldString.append(text: "Content-Disposition: form-data; name=\"\(name)\"; filename=\"image\"\r\n")
        fieldString.append(text: "Content-Type: text/plain; charset=ISO-8859-1\r\n")
        fieldString.append(text: "Content-Transfer-Encoding: 8bit\r\n")
        fieldString.append(text: "\r\n")
        fieldString.append(text: "\(value)\r\n")
        return fieldString
    }
}
