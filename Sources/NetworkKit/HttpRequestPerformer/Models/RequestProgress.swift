//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 21/08/2023.
//

import Foundation

public struct RequestProgress {
    public var percentage: Double {
        abs(Double(data.count) / Double(expectedContentLength))
    }
    public var bytesCount: Int {
        data.count
    }

    private let data: Data
    private let expectedContentLength: Int

    init(
        data: Data,
        expectedContentLength: Int
    ) {
        self.data = data
        self.expectedContentLength = expectedContentLength
    }
}
