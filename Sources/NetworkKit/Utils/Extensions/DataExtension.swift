//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 13/08/2023.
//

import Foundation

extension Data {
    var prettyPrintedJSON: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: String.Encoding.utf8) else { return nil }
        return prettyPrintedString
    }

    mutating func append(text: String) {
        guard let data = text.data(using: .utf8, allowLossyConversion: true) else { return }
        append(data)
    }
}
