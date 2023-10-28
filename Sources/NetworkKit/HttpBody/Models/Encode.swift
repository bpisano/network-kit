//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 20/08/2023.
//

import Foundation

public struct Encode<T: Encodable>: HttpBody {
    private let object: T

    public var overrideHeaders: HttpHeaders? {
        HttpHeader("Content-Type", value: "application/json")
    }

    public var debugDescription: String {
        if let object = object as? CustomDebugStringConvertible {
            return object.debugDescription
        } else if let prettyPrintedJSON = try? JSONEncoder().encode(object).prettyPrintedJSON {
            return prettyPrintedJSON
        }
        return "\(object)"
    }

    public init(_ object: @autoclosure () -> T) {
        self.object = object()
    }

    public func encode(using jsonEncoder: JSONEncoder) throws -> Data {
        try jsonEncoder.encode(object)
    }
}
