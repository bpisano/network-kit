//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 11/08/2023.
//

import Foundation

protocol RequestModifier {
    func build(
        request: inout URLRequest,
        httpRequest: some HttpRequest,
        server: Server
    ) throws
}
