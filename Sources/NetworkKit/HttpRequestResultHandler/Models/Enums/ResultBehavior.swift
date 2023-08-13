//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 11/08/2023.
//

import Foundation

enum ResultBehavior {
    case decodeData(_ data: Data)
    case throwError(_ error: Error)
    case refreshAccessToken
}
