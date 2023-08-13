//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 11/08/2023.
//

import Foundation

struct QueryParametersModifier: RequestModifier {
    func build(
        request: inout URLRequest,
        httpRequest: HttpRequest,
        server: Server
    ) throws {
        guard let url = urlComponents(for: httpRequest, server: server).url else {
            fatalError("Invalid url for server \(server)")
        }
        request.url = url
    }
    
    private func urlComponents(for httpRequest: HttpRequest, server: Server) -> URLComponents {
        var components: URLComponents = URLComponents()
        components.scheme = server.scheme
        components.host = server.host
        components.port = server.port
        components.path = httpRequest.path
        if let queryParameters = httpRequest.queryParameters {
            components.queryItems = queryParameters.queryItems(dateFormatter: httpRequest.dateFormatter)
        }
        return components
    }
}

extension RequestModifier where Self == QueryParametersModifier {
    static var queryParameters: Self {
        .init()
    }
}
