//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 11/08/2023.
//

import Foundation

struct TimeoutModifier: RequestModifier {
    func build(
        request: inout URLRequest,
        httpRequest: some HttpRequest,
        client: Client
    ) throws {
        request.timeoutInterval = httpRequest.timeout
    }
}

extension RequestModifier where Self == TimeoutModifier {
    static var timeout: Self {
        .init()
    }
}
