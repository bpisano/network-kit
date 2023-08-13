//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 09/08/2023.
//

import Foundation

public enum HttpMethod: String, CaseIterable, Identifiable, Hashable {
    case `get` = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
    case head = "HEAD"
    case options = "OPTIONS"
    case connect = "CONNECT"
    case trace = "TRACE"
    
    public var id: String {
        rawValue
    }
}
