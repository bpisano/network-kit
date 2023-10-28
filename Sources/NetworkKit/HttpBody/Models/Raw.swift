//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 20/08/2023.
//

import Foundation

public struct Raw: HttpBody {
    private let data: Data

    public var debugDescription: String {
        String(data: data, encoding: .utf8) ?? "Unable to represent raw data as String."
    }

    public init(_ data: Data) {
        self.data = data
    }

    public func encode(using jsonEncoder: JSONEncoder) throws -> Data {
        data
    }
}
