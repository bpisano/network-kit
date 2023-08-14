//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 14/08/2023.
//

import Foundation

public protocol HttpDataRequest: Request {
    var body: [MultiformDataField] { get }
}

extension HttpDataRequest {
    var bodyData: Data {
        body.reduce(Data()) { data, field in
            var newData: Data = data
            newData.append(field.data)
            return newData
        }
    }

    func urlRequest(server: Server) throws -> URLRequest {
        try HttpRequestBuilder()
            .using(.method)
            .using(.queryParameters)
            .using(.body)
            .using(.headers)
            .using(.timeout)
            .using(.cache)
            .buildRequest(from: self, server: server)
    }

    func failureBehavior(for statusCode: Int) -> FailureBehavior {
        guard statusCode == 401 || statusCode == 403 else { return .default }
        return .refreshAccessToken
    }
}
