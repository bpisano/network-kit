//
//  TimeoutBuilder.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

struct TimeoutBuilder: RequestModifier, Sendable {
    let timeout: TimeInterval

    func modify(_ urlRequest: inout URLRequest) throws {
        urlRequest.timeoutInterval = timeout
    }
}
