//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 20/08/2023.
//

import Foundation

public struct Raw: HttpBody {
    private let data: Data

    public init(data: Data) {
        self.data = data
    }

    public func encode(using jsonEncoder: JSONEncoder) throws -> Data {
        data
    }
}
