//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 14/08/2023.
//

import Foundation

public enum MultiformDataField {
    case text(name: String, value: String)
    case data(name: String, data: Data, mimeType: String)

    var data: Data {
        switch self {
        case let .text(name, value):
            return textField(named: name, value: value)
        case let .data(name, data, mimeType):
            return dataField(named: name, data: data, mimeType: mimeType)
        }
    }

    private func textField(
        named name: String,
        value: String
    ) -> Data {
        let boundary: String = UUID().uuidString
        var fieldString: Data = Data()
        fieldString.append(text: "--\(boundary)\r\n")
        fieldString.append(text: "Content-Disposition: form-data; name=\"\(name)\"\r\n")
        fieldString.append(text: "Content-Type: text/plain; charset=ISO-8859-1\r\n")
        fieldString.append(text: "Content-Transfer-Encoding: 8bit\r\n")
        fieldString.append(text: "\r\n")
        fieldString.append(text: "\(value)\r\n")
        return fieldString
    }

    private func dataField(
        named name: String,
        data: Data,
        mimeType: String
    ) -> Data {
        let boundary: String = UUID().uuidString
        var fieldData: Data = Data()
        fieldData.append(text: "--\(boundary)\r\n")
        fieldData.append(text: "Content-Disposition: form-data; name=\"\(name)\"\r\n")
        fieldData.append(text: "Content-Type: \(mimeType)\r\n")
        fieldData.append(text: "\r\n")
        fieldData.append(data)
        fieldData.append(text: "\r\n")
        return fieldData
    }
}
