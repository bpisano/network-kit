//
//  RequestModifier.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

protocol RequestModifier {
    func modify(_ urlRequest: inout URLRequest) throws
}
