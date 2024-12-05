//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 09/08/2023.
//

import Foundation

/// An enum representing various HTTP methods that can be used in network requests.
public enum HttpMethod: String, CaseIterable, Identifiable, Hashable, Codable, Sendable {
    /// The HTTP GET method requests data from a specified resource.
    case get = "GET"
    /// The HTTP POST method sends data to the server to create a new resource.
    case post = "POST"
    /// The HTTP PUT method sends data to the server to update or create a resource.
    case put = "PUT"
    /// The HTTP DELETE method deletes a specified resource.
    case delete = "DELETE"
    /// The HTTP PATCH method is used to apply partial modifications to a resource.
    case patch = "PATCH"
    /// The HTTP HEAD method requests the headers of a specified resource.
    case head = "HEAD"
    /// The HTTP OPTIONS method describes the communication options for the target resource.
    case options = "OPTIONS"
    /// The HTTP CONNECT method establishes a network connection to a server.
    case connect = "CONNECT"
    /// The HTTP TRACE method performs a message loop-back test along the path to the target resource.
    case trace = "TRACE"

    /// The unique identifier of the HTTP method, which is the raw string value of the enum case.
    public var id: String {
        rawValue
    }
}
