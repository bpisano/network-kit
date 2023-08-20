//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 20/08/2023.
//

import Foundation

public struct EmptyBody: HttpBody {
    public func encode(using jsonEncoder: JSONEncoder) throws -> Data {
        .init()
    }
}
