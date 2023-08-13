//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 09/08/2023.
//

import Foundation

public extension JSONDecoder.DateDecodingStrategy {
    /// Decodes date formatted as `2022-10-11T11:25:36.897+02:00`.
    static var datefns: JSONDecoder.DateDecodingStrategy {
        return .custom { decoder in
            let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
            let dateString: String = try container.decode(String.self)
            if let date = ISO8601DateFormatter.datefns.date(from: dateString) {
                return date
            }
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string \"\(dateString)\" using the datefns decoding strategy."
            )
        }
    }
}
