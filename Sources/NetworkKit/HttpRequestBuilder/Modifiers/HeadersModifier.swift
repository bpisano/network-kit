//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 11/08/2023.
//

import Foundation

struct HeadersModifiers: RequestModifier {
    func build(
        request: inout URLRequest,
        httpRequest: some HttpRequest,
        client: Client
    ) throws {
        addRequestHeaders(request: &request, httpRequest: httpRequest)
        addAuthorizationHeader(request: &request, httpRequest: httpRequest, client: client)
    }

    private func addRequestHeaders(request: inout URLRequest, httpRequest: some HttpRequest) {
        httpRequest.makeHeaders()
            .dictionaryHeaders(dateFormatter: httpRequest.dateFormatter)
            .forEach { key, value in
                request.addValue(value, forHTTPHeaderField: key)
            }
    }

    private func addAuthorizationHeader(request: inout URLRequest, httpRequest: some HttpRequest, client: Client) {
        guard httpRequest.accessTokenType != .none else { return }
        guard let accessToken = client.accessTokenProvider?.accessToken else { return }
        guard let headerValue = httpRequest.accessTokenType.header(withToken: accessToken) else { return }
        request.addValue(headerValue, forHTTPHeaderField: "authorization")
    }
}

extension RequestModifier where Self == HeadersModifiers {
    static var headers: Self {
        .init()
    }
}
