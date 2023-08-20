//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 19/08/2023.
//

import Foundation

@resultBuilder
public struct HttpHeadersBuilder {
    public static func buildBlock(_ components: HttpHeader...) -> HttpHeaders {
        components.reduce(into: [String: String]()) { headers, header in
            headers[header.key] = header.value
        }
    }
}
