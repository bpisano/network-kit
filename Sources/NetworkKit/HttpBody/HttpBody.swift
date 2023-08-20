//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 18/08/2023.
//

import Foundation

public protocol HttpBody {
    @HttpHeadersBuilder
    var overrideHeaders: HttpHeaders? { get }

    func encode(using jsonEncoder: JSONEncoder) throws -> Data
}

public extension HttpBody {
    var overrideHeaders: HttpHeaders? { nil }
}
