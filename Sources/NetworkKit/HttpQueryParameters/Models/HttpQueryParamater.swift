//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 19/08/2023.
//

import Foundation

public struct HttpQueryParameter {
    public let key: String
    public let value: String

    public init(_ key: String, value: String) {
        self.key = key
        self.value = value
    }

    var queryItem: URLQueryItem {
        .init(name: key, value: value)
    }
}
