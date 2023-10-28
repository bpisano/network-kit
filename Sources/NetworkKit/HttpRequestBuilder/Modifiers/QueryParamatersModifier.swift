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
        httpRequest: some HttpRequest,
        client: Client
    ) throws {
        guard let url = urlComponents(for: httpRequest, client: client).url else {
            fatalError("Invalid url for client \(client)")
        }
        request.url = url
    }
    
    private func urlComponents(for httpRequest: some HttpRequest, client: Client) -> URLComponents {
        var components: URLComponents = URLComponents()
        components.scheme = client.scheme
        components.host = client.host
        components.port = client.port
        components.path = resolvePath(httpRequest.path)
        if let queryParameters = httpRequest.queryParameters {
            components.queryItems = queryParameters.queryItems(dateFormatter: httpRequest.dateFormatter)
        }
        return components
    }

    private func resolvePath(_ path: String) -> String {
        guard let firstCharacter = path.first else { return path }
        if firstCharacter != "/" {
            return "/" + path
        }
        return path
    }
}

extension RequestModifier where Self == QueryParametersModifier {
    static var queryParameters: Self {
        .init()
    }
}
